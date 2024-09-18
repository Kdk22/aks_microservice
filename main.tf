
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

#This resource group is used to store state file
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.prefix}-${var.resource_name}"
  location = var.location
  tags = {
    Description = "state file storage"
  }

}
#This storage account is used to store state file
resource "azurerm_storage_account" "storage_account" {
   name     = "${var.prefix}-${var.resource_name}-${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_tf_state.name
  location                 = azurerm_resource_group.rg_tf_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blob_container" {
  name     = "${var.prefix}-${var.resource_name}-${random_integer.suffix.result}"
  storage_account_name  = azurerm_storage_account.state_storage_account.name
  container_access_type = "private"
}

# This resource group is used for all the resources creation
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.prefix}-${var.resource_name}-${random_integer.suffix.result}"
  location = var.location
  tags = {
    Description = "state file storage"
  }

}


