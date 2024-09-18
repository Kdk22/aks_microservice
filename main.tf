
provider "azurerm" {
  features {}
}
# resource "random_integer" "suffix" {
#   min = 10000
#   max = 99999
# }
# resource "random_id" "seed" {
#   byte_length = 4
# }


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
  name                     = "${var.prefix}-${var.resource_name}-${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.example[0].name
  location                 = azurerm_resource_group.example[0].location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_storage_container" "blob_container" {
  name                  = "${var.prefix}-${var.resource_name}-${random_integer.suffix.result}"
  storage_account_name  = azurerm_storage_account.state_storage_account.name
  container_access_type = "private"
}




