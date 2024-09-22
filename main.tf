

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
    module.ServicePrincipal
  ]
}

resource "azurerm_key_vault_secret" "example" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [
    module.keyvault
  ]
}





