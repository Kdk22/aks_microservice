data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {
}
# data "azuread_user" "user_details"{
#   user_principal_name = "utft0_outlook.com#EXT#@utft0outlook.onmicrosoft.com"
# }

data "azurerm_key_vault" "created_kv" {
  name          =      var.keyvault_name
  resource_group_name = azurerm_resource_group.rg["rg2"].name

  depends_on = [ azurerm_resource_group.rg ]
}

data "azuread_service_principal" "existing-sp" {
  display_name = var.service_principal_name
}

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
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}


# module "ServicePrincipal" {
#   source                 = "./modules/sp"
#   service_principal_name = var.service_principal_name
#   depends_on = [
#     azurerm_resource_group.rg
#   ]


# }


# locals  {
#   roles = {
#     contributor = "Contributor"
#     key_vault = "Key Vault Administrator"

#   }
# }

# resource "azurerm_role_assignment" "rolespn" {

# for_each = local.roles
#   scope                = data.azurerm_subscription.primary.id
#   role_definition_name = each.value
#   principal_id         = module.ServicePrincipal.service_principal_object_id
#   #data.azurerm_client_config.current.object_id if you want to give permission to yourself but
#   # i have already given
#   depends_on = [module.ServicePrincipal]

#     lifecycle {
#     ignore_changes = all
#   }
# }

# resource "azurerm_role_assignment" "new_rolespn" {

# for_each = local.roles
#   scope                = data.azurerm_subscription.primary.id
#   role_definition_name = each.value
#   principal_id         = data.azuread_service_principal.existing-sp.object_id
#   #data.azurerm_client_config.current.object_id if you want to give permission to yourself but
#   # i have already given
#   depends_on = [module.ServicePrincipal]

#     lifecycle {
#     ignore_changes = all
#   }
# }



# module "keyvault" {
#   source              = "./modules/kv"
#   keyvault_name       = var.keyvault_name
#   resource_group_name = azurerm_resource_group.rg["rg2"].name
#   location            = azurerm_resource_group.rg["rg2"].location

#   depends_on = [
#     module.ServicePrincipal, azurerm_resource_group.rg
#   ]
# }

# # storing service connection to key vault

# locals {
#   secrets = {
#     spn-sc       = module.ServicePrincipal.service_principal_password_value
#     github-token = var.github_token
#     ssh-pub-key  = var.ssh_public_key
#     ado-token    = var.ado_token
#   }
# }

# # resource "azurerm_key_vault_secret" "example" {
# #   for_each     = local.secrets
# #   name         = each.key
# #   value        = each.value
# #   key_vault_id = module.keyvault.keyvault_id

# #   depends_on = [
# #     module.keyvault, azurerm_key_vault_access_policy.kv_access_policy_me, azurerm_key_vault_access_policy.kv_access_policy_sc, azurerm_key_vault_access_policy.kv_access_policy_user
# #   ]
# # }

# # give permission to sp to access keyvault

# # this permission is for service connection from app registration, this is given to store database secrets to key vault
# resource "azurerm_key_vault_access_policy" "kv_access_policy_sc" {

#   key_vault_id = module.keyvault.keyvault_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = module.ServicePrincipal.service_principal_object_id
#   key_permissions = [
#     "Get", "List"
#   ]
#   secret_permissions = [
#     "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"
#   ]

#   depends_on = [module.keyvault]
# }

# # to the current user
# resource "azurerm_key_vault_access_policy" "kv_access_policy_user" {

#   key_vault_id = data.azurerm_key_vault.created_kv.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azuread_user.user_details.object_id
#   secret_permissions = [
#     "Get",
#     "List",
#     "Recover",
#   ]

#   key_permissions = [
#     "Get", "Backup", "Delete", "Purge", "Recover", "Restore",
#   ]

#   certificate_permissions = [
#     "Get", "Backup", "Import", "List", "Purge", "Recover", "Restore"
#   ]

#   depends_on = [module.keyvault]
# }

# # permission to my self
# resource "azurerm_key_vault_access_policy" "kv_access_policy_me" {
#   key_vault_id       = data.azurerm_key_vault.created_kv.id
#   tenant_id          = data.azurerm_client_config.current.tenant_id
#   object_id          = data.azurerm_client_config.current.object_id
#   key_permissions    = ["Get", "List"]
#   secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"]

#   depends_on = [module.keyvault]
# }

# provider "azuredevops" {
#   org_service_url       = var.ado_org_service_url
#   # personal_access_token = var.ado_token
# }

# module "devops" {
#   source                   = "./modules/ado"
#   project_name             = var.project_name
#   ado_github_id            = var.ado_github_id
#   ado_pipeline_yaml_path_1 = var.ado_pipeline_yaml_path_1
#   github_pat               = var.github_token
#   service_principal_id     = module.ServicePrincipal.service_principal_application_id
#   service_principal_secret = module.ServicePrincipal.service_principal_password_value
#   spn_tenant_id            = data.azurerm_client_config.current.tenant_id
#   subscription_name        = data.azurerm_subscription.primary.display_name

#   spn_subscription_id = data.azurerm_client_config.current.subscription_id




#   providers = {
#     azuredevops = azuredevops
#   }

#   depends_on = [
#     module.keyvault, module.ServicePrincipal
#   ]
# }


module "vnet" {
  source                      = "./modules/vnet"
  AKS_VNET_NAME               = var.AKS_VNET_NAME
  LOCATION                    = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME         = azurerm_resource_group.rg["rg2"].name
  AKS_ADDRESS_SPACE           = var.AKS_ADDRESS_SPACE
  AKS_SUBNET_ADDRESS_PREFIX   = var.AKS_SUBNET_ADDRESS_PREFIX
  AKS_SUBNET_NAME             = var.AKS_SUBNET_NAME
  APPGW_SUBNET_NAME           = var.APPGW_SUBNET_NAME
  APPGW_SUBNET_ADDRESS_PREFIX = var.APPGW_SUBNET_ADDRESS_PREFIX
  ACR_VNET_NAME               = var.ACR_VNET_NAME
  ACR_SUBNET_NAME             = var.ACR_SUBNET_NAME
  ACR_ADDRESS_SPACE           = var.ACR_ADDRESS_SPACE
  ACR_SUBNET_ADDRESS_PREFIX   = var.ACR_SUBNET_ADDRESS_PREFIX
  AGENT_VNET_NAME             = var.AGENT_VNET_NAME
  AGENT_ADDRESS_SPACE         = var.AGENT_ADDRESS_SPACE
  AGENT_SUBNET_NAME           = var.AGENT_SUBNET_NAME
  AGENT_SUBNET_ADDRESS_PREFIX = var.AGENT_SUBNET_ADDRESS_PREFIX

  depends_on = [azurerm_resource_group.rg]
}

module "agent-vm" {
  source              = "./modules/agentvm"
  AGENT_VM_NAME       = var.AGENT_VM_NAME
  LOCATION            = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME = azurerm_resource_group.rg["rg2"].name
  ADMIN_USERNAME      = var.ADMIN_USERNAME
  ADMIN_PASSWORD      = var.ADMIN_PASSWORD
  VM_SIZE             = var.VM_SIZE
  AGENT_SUBNET_ID     = module.vnet.agent_vnet_subnet_id

  depends_on = [
    module.vnet, azurerm_resource_group.rg
  ]
}

module "acr" {
  source                      = "./modules/acr"
  PRIVATE_ACR_NAME            = var.PRIVATE_ACR_NAME
  LOCATION                    = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME         = azurerm_resource_group.rg["rg2"].name
  SERVICE_PRINCIPAL_OBJECT_ID = data.azuread_service_principal.existing-sp.object_id
  ACR_SKU                     = var.ACR_SKU
  AKS_VNET_ID                 = module.vnet.aks_vnet_id
  AGENT_VNET_ID               = module.vnet.agent_vnet_id
  ACR_VNET_ID                 = module.vnet.acr_vnet_id
  AGENT_SUBNET_ID             = module.vnet.agent_vnet_subnet_id
  ACR_SUBNET_ID               = module.vnet.acr_subnet_id

  depends_on = [module.vnet, azurerm_resource_group.rg]

}

module "sqldb" {
  source                      = "./modules/sqldb"
  AKS_SUBNET_ID               = module.vnet.aks_subnet_id
  AKS_SUBNET_SERVICE_ENDPOINT = module.vnet.aks_subnet_service_endpoints
  LOCATION                    = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME         = azurerm_resource_group.rg["rg2"].name
  COLLATION                   = var.COLLATION
  DB_NAME                     = var.DB_NAME
  DBPASSWORD                  = var.DBPASSWORD
  DBSERVER_NAME               = var.DBSERVER_NAME
  DBUSERNAME                  = var.DBUSERNAME

  depends_on = [
    module.vnet, azurerm_resource_group.rg
  ]

}

module "appgate" {
  source               = "./modules/appgate"
  LOCATION             = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME  = azurerm_resource_group.rg["rg2"].name
  APP_GATEWAY_NAME     = var.APP_GATEWAY_NAME
  VIRTUAL_NETWORK_NAME = var.VIRTUAL_NETWORK_NAME
  APPGW_PUBLIC_IP_NAME = var.APPGW_PUBLIC_IP_NAME
  APPGW_SUBNET_ID      = module.vnet.appgw_subnet_id
  depends_on           = [module.vnet, azurerm_resource_group.rg]


}

module "log-analytics" {
  source              = "./modules/loga"
  LOCATION            = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME = azurerm_resource_group.rg["rg2"].name

  depends_on = [azurerm_resource_group.rg]
}

module "azure-fron-door" {
  source                 = "./modules/afd"
  RESOURCE_GROUP_NAME    = azurerm_resource_group.rg["rg2"].name
  APPGWPUBLIC_IP_ADDRESS = module.appgate.ip_address

  depends_on = [
    module.appgate, azurerm_resource_group.rg
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
  source              = "./modules/aks/"
  NAME                = var.ACR_NAME
  LOCATION            = azurerm_resource_group.rg["rg2"].location
  RESOURCE_GROUP_NAME = azurerm_resource_group.rg["rg2"].name
  AKS_VNET_ID         = module.vnet.aks_vnet_id
  ACR_VNET_ID         = module.vnet.acr_vnet_id
  AGENT_VNET_ID       = module.vnet.agent_vnet_id
  ACR_ID              = module.acr.acr_id
  AKS_SUBNET_ID       = module.vnet.aks_subnet_id
  APPGATEWAY_ID       = module.appgate.appgw_id
  APPGW_SUBNET_ID     = module.vnet.appgw_subnet_id
  DNS_PREFIX          = var.DNS_PREFIX
  rg_id               = azurerm_resource_group.rg["rg2"].id
  ssh_public_key      = var.ssh_public_key

  depends_on = [
     module.acr, module.vnet, module.appgate, azurerm_resource_group.rg
  ]

}





