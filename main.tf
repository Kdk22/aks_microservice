

resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups
  name     = each.value.name
  location = each.value.location
  tags = {
    Description = each.value.tag
  }
}

#Here index 0 resource group rg1 is used for state file storage and rg2 is used for other resources. 

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg["rg1"].name
  location                 = azurerm_resource_group.rg["rg1"].location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_storage_container" "blob_container" {
  name                  = var.blob_state_file
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

module "ServicePrincipal" {
  source                 = "./modules/sp"
  service_principal_name = var.service_principal_name

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_role_assignment" "rolespn" {

  scope                = var.subscription_path
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}


module "keyvault" {
  source                      = "./modules/kv"
  keyvault_name               = var.keyvault_name
  resource_group_name         = azurerm_resource_group.rg["rg2"].name
  location                    = azurerm_resource_group.rg["rg2"].location
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal,  azurerm_resource_group.rg
  ]
}

# storing service connection to key vault

locals {
  secrets = {
  spn-id = module.ServicePrincipal.client_id
  spn-sc = module.ServicePrincipal.client_secret
  github-token = var.github-token
}
}

resource "azurerm_key_vault_secret" "example" {
  for_each            = local.secrets
  name                = each.key
  value               = each.value
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [
    module.keyvault
  ]
}


data "azurerm_key_vault_secret" "git_pat" {
  name         = "github-token"
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [azurerm_key_vault_secret.example]
}

provider "azuredevops" {
  org_service_url       = var.ado_org_service_url
  personal_access_token = var.ado-token
}

module "devops" {
  source                   = "./modules/ado"
  project_name             = var.project_name
  ado_github_id            = var.ado_github_id
  ado_pipeline_yaml_path_1 = var.ado_pipeline_yaml_path_1
  github_pat           = data.azurerm_key_vault_secret.git_pat.value

  providers = {
    azuredevops = azuredevops
  }

  depends_on = [
    module.keyvault
  ]
}


module "vnet"{
  source = "./modules/vnet"
  AKS_VNET_NAME = var.AKS_VNET_NAME
  LOCATION = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME      = azurerm_resource_group.rg["rg2"].name
  AKS_ADDRESS_SPACE = var.AKS_ADDRESS_SPACE
  AKS_SUBNET_ADDRESS_PREFIX = var.AKS_SUBNET_ADDRESS_PREFIX
  AKS_SUBNET_NAME = var.AKS_SUBNET_NAME
  APPGW_SUBNET_NAME = var.APPGW_SUBNET_NAME
  APPGW_SUBNET_ADDRESS_PREFIX = var.APPGW_SUBNET_ADDRESS_PREFIX
  ACR_VNET_NAME = var.ACR_VNET_NAME
  ACR_SUBNET_NAME = var.ACR_SUBNET_NAME
  ACR_ADDRESS_SPACE = var.ACR_ADDRESS_SPACE
  ACR_SUBNET_ADDRESS_PREFIX = var.ACR_SUBNET_ADDRESS_PREFIX
  AGENT_VNET_NAME = var.AGENT_VNET_NAME
  AGENT_ADDRESS_SPACE = var.AGENT_ADDRESS_SPACE
  AGENT_SUBNET_NAME = var.AGENT_SUBNET_NAME
  AGENT_SUBNET_ADDRESS_PREFIX = var.AGENT_SUBNET_ADDRESS_PREFIX

  depends_on = [  azurerm_resource_group.rg ]
}

module "agent-vm"{
  source = "./modules/agentvm"
AGENT_VM_NAME = var.AGENT_VM_NAME
 LOCATION = azurerm_resource_group.rg["rg2"].location
 RESOURCE_GROUP_NAME  = azurerm_resource_group.rg["rg2"].name
 ADMIN_USERNAME  = var.ADMIN_USERNAME
 ADMIN_PASSWORD  = var.ADMIN_PASSWORD
 VM_SIZE = var.VM_SIZE
 AGENT_SUBNET_ID = module.vnet.agent_vnet_subnet_id

 depends_on = [
    module.vnet,  azurerm_resource_group.rg
  ]
}

module "acr"{
  source = "./modules/acr"
PRIVATE_ACR_NAME = var.PRIVATE_ACR_NAME
LOCATION = azurerm_resource_group.rg["rg2"].location
RESOURCE_GROUP_NAME  = azurerm_resource_group.rg["rg2"].name
SERVICE_PRINCIPAL_OBJECT_ID = module.ServicePrincipal.service_principal_object_id
ACR_SKU = var.ACR_SKU
AKS_VNET_ID = module.vnet.aks_vnet_id
AGENT_VNET_ID = module.vnet.agent_vnet_id
ACR_VNET_ID = module.vnet.acr_vnet_id
AGENT_SUBNET_ID = module.vnet.agent_vnet_subnet_id
ACR_SUBNET_ID = module.vnet.acr_subnet_id

depends_on = [ module.ServicePrincipal, module.vnet,  azurerm_resource_group.rg ]

}

module "sqldb" {
  source = "./modules/sqldb"
  AKS_SUBNET_ID = module.vnet.aks_subnet_id
  AKS_SUBNET_SERVICE_ENDPOINT = module.vnet.aks_subnet_service_endpoints
  LOCATION = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME  = azurerm_resource_group.rg["rg2"].name
  COLLATION = var.COLLATION
  DB_NAME = var.DB_NAME
DBPASSWORD = var.DBPASSWORD
DBSERVER_NAME = var.DBSERVER_NAME
DBUSERNAME = var.DBUSERNAME

depends_on = [
   module.vnet,  azurerm_resource_group.rg
  ]

}

module "appgate"{
  source = "./modules/appgate"
LOCATION = azurerm_resource_group.rg["rg2"].location
RESOURCE_GROUP_NAME  = azurerm_resource_group.rg["rg2"].name
  APP_GATEWAY_NAME = var.APP_GATEWAY_NAME
  VIRTUAL_NETWORK_NAME = var.VIRTUAL_NETWORK_NAME
  APPGW_PUBLIC_IP_NAME = var.APPGW_PUBLIC_IP_NAME
  APPGW_SUBNET_ID = module.vnet.appgw_subnet_id
  depends_on = [ module.vnet,  azurerm_resource_group.rg ]


}

module "log-analytics" {
  source = "./modules/loga"
  LOCATION = azurerm_resource_group.rg["rg2"].location
RESOURCE_GROUP_NAME  = azurerm_resource_group.rg["rg2"].name

depends_on = [  azurerm_resource_group.rg ]
}

module "azure-fron-door" {
  source = "./modules/afd"
RESOURCE_GROUP_NAME  = azurerm_resource_group.rg["rg2"].name
APPGWPUBLIC_IP_ADDRESS =  module.appgate.ip_address

depends_on = [
     module.appgate,  azurerm_resource_group.rg
  ]
}
# module "aks"{
#   source = "./modules/aks"
# }

# resource "local_file" "kubeconfig" {
#   depends_on   = [module.aks]
#   filename     = "./kubeconfig"
#   content      = module.aks.config
  
# }

# create Azure Kubernetes Service
module "aks" {
  source                 = "./modules/aks/"
  SERVICE_PRINCIPLE_OBJECT_ID = module.ServicePrincipal.service_principal_object_id
  NAME = var.ACR_NAME
    LOCATION = azurerm_resource_group.rg["rg2"].location
RESOURCE_GROUP_NAME  = azurerm_resource_group.rg["rg2"].name
AKS_VNET_ID = module.vnet.aks_vnet_id
ACR_VNET_ID = module.vnet.acr_vnet_id
AGENT_VNET_ID = module.vnet.agent_vnet_id
ACR_ID = module.acr.acr_id
AKS_SUBNET_ID = module.vnet.aks_subnet_id
APPGATEWAY_ID = module.appgate.appgw_id
APPGW_SUBNET_ID = module.vnet.appgw_subnet_id
CLIENT_ID = module.ServicePrincipal.client_id
CLIENT_SECRET = module.ServicePrincipal.client_secret
DNS_PREFIX = var.DNS_PREFIX
rg_id = azurerm_resource_group.rg["rg2"].id
ssh_public_key = var.SSH_PUBLIC_KEY


  depends_on = [
    module.ServicePrincipal, module.acr, module.vnet, module.appgate,  azurerm_resource_group.rg
  ]

}





