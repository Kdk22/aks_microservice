


# vnet output
output "aks_vnet_id" {
  value = azurerm_virtual_network.aks-vnet.id
}

output "acr_vnet_id" {
  value = azurerm_virtual_network.acr-vnet.id
}

output "agent_vnet_id" {
  value = azurerm_virtual_network.agent-vnet.id
}

# subnet output
output "aks_subnet_id" {
  value = azurerm_subnet.aks-subnet.id
}
output "appgw_subnet_id" {
  value = azurerm_subnet.appgw-subnet.id
}
output "acr_subnet_id" {
  value = azurerm_subnet.acr-subnet.id
}

output "agent_vnet_subnet_id" {
  value = azurerm_subnet.agent-vnet-subnet.id
}

output "aks_subnet_service_endpoints"{
  value = azurerm_subnet.aks-subnet.service_endpoints
}

output "aks_subnet_name" {
  value = azurerm_subnet.aks-subnet.name
}

output "aks_subnet_address_prefixes" {
  value = azurerm_subnet.aks-subnet.address_prefixes
}




# vnet peering output
output "aks_acr_peering_id" {
  value = azurerm_virtual_network_peering.aks-acr.id
}

output "acr_aks_peering_id" {
  value = azurerm_virtual_network_peering.acr-aks.id
}

output "acr_agent_peering_id" {
  value = azurerm_virtual_network_peering.acr-agent.id
}

output "agent_acr_peering_id" {
  value = azurerm_virtual_network_peering.agent-acr.id
}

output "aks_agent_peering_id" {
  value = azurerm_virtual_network_peering.aks-agent.id
}

output "agent_aks_peering_id" {
  value = azurerm_virtual_network_peering.agent-aks.id
}


