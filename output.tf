output "resource_group_names" {
  value = azurerm_resource_group.rg[*].name
}