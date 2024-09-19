variable "storage_account_name" {
  type        = string
  description = "Naming prefix for resources"
  default     = "backupstatefile"
}


variable "blob_state_file" {
  type        = string
  description = "This is resource group for state file storage"
  default     = "stateblob"
}
variable "resource_groups" {
  type = map(object({
    location = string
    name     = string
    tag      = string
  }))
  default = {
    "rg1" = { location = "westus2", name = "store-tfstatefile", tag = "storestatefile" },
    "rg2" = { location = "westus2", name = "aks-deployment", tag = "aks-project2" },

  }
}

variable "service_principal_name" {
  type = string
  description = "This is service principle name"
  
}
variable "subscription_path" {
    type = string
    description = "The url of subscription which "
  
}
