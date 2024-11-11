output "acr_login_server" {
  description = "The URL of the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server

}
output "acr_id" {
  description = "The ID of the Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}
output "acr_private_dns_zone_id" {
  description = "The ID of the private DNS zone for the ACR"
  value       = azurerm_private_dns_zone.acr-dns-zone.id
}
output "acr_private_endpoint_id" {
  description = "The ID of the private endpoint for the ACR"
  value       = azurerm_private_endpoint.acr_private_endpoint.id
}
output "acr_vnet_link_id" {
  description = "The ID of the virtual network link for the ACR"
  value       = azurerm_private_dns_zone_virtual_network_link.acr-vnet-link.id
}

output "aks_vnet_link_id" {
  description = "The ID of the virtual network link for the AKS VNet"
  value       = azurerm_private_dns_zone_virtual_network_link.aks-vnet-link.id
}

output "agent_vnet_link_id" {
  description = "The ID of the virtual network link for the Agent VNet"
  value       = azurerm_private_dns_zone_virtual_network_link.agent-vnet-link.id
}