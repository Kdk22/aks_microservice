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
    "rg1" = { location = "westus2", name = "store-state-file-rg", tag = "store-state-file-rg" },
    "rg2" = { location = "westus2", name = "aks-terra-pro-rg", tag = "aks-terra-pro-rg" },

  }
}

variable "service_principal_name" {
  type        = string
  description = "This is service principle name"
  default     = "aks-project0-spn"

}

variable "app_registration_name" {
  type        = string
  description = "This is app registration name"
  default     = "aks-project-app"

}
variable "subscription_id" {
  type        = string
  description = "The subscription id "
  default     = "75e2cef5-d3ca-42ff-8b0d-4dab256b9453"
}

variable "keyvault_name" {
  type        = string
  description = "Key Vault Name"
  default     = "aks-project2"
}

variable "github_token" {
  type        = string
  description = "The pat"
  sensitive   = true
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
  default     = "blank"

}

variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "Aks-Terra"

}
variable "ado_token" {
  type        = string
  description = "Azure Devops Token"
  sensitive   = true
}

# vnet variables 
variable "AKS_VNET_NAME" { type = string }
variable "AKS_ADDRESS_SPACE" { type = string }
variable "AKS_SUBNET_NAME" { type = string }
variable "AKS_SUBNET_ADDRESS_PREFIX" { type = string }
variable "APPGW_SUBNET_NAME" { type = string }
variable "APPGW_SUBNET_ADDRESS_PREFIX" { type = string }



variable "ACR_VNET_NAME" { type = string }
variable "ACR_SUBNET_NAME" { type = string }
variable "ACR_SUBNET_ADDRESS_PREFIX" { type = string }
variable "ACR_ADDRESS_SPACE" { type = string }

variable "AGENT_VNET_NAME" { type = string }
variable "AGENT_SUBNET_NAME" { type = string }
variable "AGENT_SUBNET_ADDRESS_PREFIX" { type = string }
variable "AGENT_ADDRESS_SPACE" { type = string }

#agent variables
variable "AGENT_VM_NAME" { type = string }
variable "VM_SIZE" { type = string }

variable "ADMIN_USERNAME" { type = string }
variable "ADMIN_PASSWORD" { type = string }

#acr
variable "PRIVATE_ACR_NAME" { type = string }
variable "ACR_SKU" { type = string }
variable "ACR_NAME" {
  type = string

}
variable "ssh_public_key" {
  type      = string
  sensitive = true
}



#db 

variable "COLLATION" { type = string }
variable "DB_NAME" { type = string }
variable "DBPASSWORD" { type = string }
variable "DBSERVER_NAME" { type = string }
variable "DBUSERNAME" { type = string }

# app gate way
variable "APP_GATEWAY_NAME" {
  type        = string
  description = "Application name. Use only lowercase letters and numbers"

}

variable "VIRTUAL_NETWORK_NAME" {
  type        = string
  description = "Virtual network name. This service will create subnets in this network."
}

variable "APPGW_PUBLIC_IP_NAME" {
  type        = string
  description = "PUBLIC IP. This service will create subnets in this network."
}
variable "DNS_PREFIX" {
  type = string

}