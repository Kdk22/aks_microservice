data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false
  sku_name                   = "premium"
  soft_delete_retention_days = 7
  enable_rbac_authorization = false
   # if we set this true we don't need access policy, as we have contributor access to service principle so it assumes the same

      lifecycle {
    prevent_destroy = true
    ignore_changes = all  # This will ignore all changes to the resource
  }
 
}



