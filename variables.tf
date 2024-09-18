variable "prefix" {
type = string
description = "Naming prefix for resources"
default = "launch-me"
}


variable "resource_name" {
    type = string
    description = "This is resource group for state file storage"
    default = "state"
}
variable "resource_groups" {
    type = map(object({
      location = string
      name = string
      tag = string
    }))
    default = {
      "rg1" = {location = "westus2", name= "store-tfstatefile", tag="storestatefile"},
        "rg2" = {location = "westus2", name= "aks-deployment", tag="aks-project2"},

    }
}
variable "location" {
  description = "Location variable"
}