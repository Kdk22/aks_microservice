output "subnet_id" {
  value = data.azurerm_subnet.aks-subnet.id
}

output "subnet_name" {
  value = data.azurerm_subnet.aks-subnet.name
}

output "subnet_address_prefixes" {
  value = data.azurerm_subnet.aks-subnet.address_prefixes
}