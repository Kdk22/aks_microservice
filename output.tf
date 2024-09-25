output "resource_group_names" {
  value = [for rg in azurerm_resource_group.rg : rg.name]
}

output "pat_secret_value" {
  value     = data.azurerm_key_vault_secret.git_pat.value
  sensitive = true
}