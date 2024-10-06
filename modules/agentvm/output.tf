output "ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
output "public_ip_id" {
    value = azurerm_public_ip.public_ip.id
}
output "network_interface_id" {
  value = azurerm_network_interface.main.id
}
output "linux_vm_id" {
  value = azurerm_linux_virtual_machine.main.id
}

output "linux_vm_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}