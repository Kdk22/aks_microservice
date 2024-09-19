
terraform {
  backend "azurerm" {
    resource_group_name  = "store-tfstatefile"
    storage_account_name = "backupstatefile"
    container_name       = "stateblob"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
