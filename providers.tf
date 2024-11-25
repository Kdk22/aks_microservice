terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.15.0"
    }
        azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}


