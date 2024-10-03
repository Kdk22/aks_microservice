output "sql_server_fqdn" {
  value = azurerm_sql_server.main.fully_qualified_domain_name
}

# Output the Database Name
output "database_name" {
  value = azurerm_sql_database.main.name
}