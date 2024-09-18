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
variable "resource_group_name" {
    type = string
    description = "This is resource group name"
    default = "aks"
}
variable "location" {
  description = "Location variable"
}