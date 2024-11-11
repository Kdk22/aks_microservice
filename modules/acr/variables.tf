variable "LOCATION" { type = string }
variable "RESOURCE_GROUP_NAME" { type = string }
variable "PRIVATE_ACR_NAME" { type = string }
variable "ACR_SKU" { type = string }
variable "AGENT_SUBNET_ID" {
  type =string
}
variable "ACR_VNET_ID" {
    type = string
}
variable "AGENT_VNET_ID" {
    type = string
}
variable "AKS_VNET_ID" {
    type = string
}
variable "SERVICE_PRINCIPAL_OBJECT_ID" {
  type = string
}
variable "ACR_SUBNET_ID" {
  type = string
  
}