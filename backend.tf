
terraform {
  backend "azurerm" {
    resource_group_name  = "store-state-file-rg"
    storage_account_name = "backupstatefile"
    container_name       = "stateblob"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
  }
      subscription_id = var.subscription_id

}
