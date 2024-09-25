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
  type        = string
  description = "This is service principle name"

}
variable "subscription_path" {
  type        = string
  description = "The url of subscription which "

}

variable "keyvault_name" {
  type = string
}

variable "github_pat" {
  type = string
}

# inside ado variables:
variable "ado_github_id" {
  type        = string
  description = "This is already created github id"
  default     = "Kdk22/aks_microservice"
}

variable "ado_pipeline_yaml_path_1" {
  type        = string
  description = "Path to the yaml for the first pipeline"

}

variable "ado_org_service_url" {
  type        = string
  description = "Path to project url"

}

variable "project_name" {
  type        = string
  description = "Project Name"

}
variable "ado_token" {
  type        = string
  description = "Azure Devops Token"
  
}
