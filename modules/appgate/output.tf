output "ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
output "appgw_id" {
  value = azurerm_application_gateway.appgateway.id
  
}