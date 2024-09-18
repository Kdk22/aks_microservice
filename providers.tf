terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.1.0"
    }
  }
}