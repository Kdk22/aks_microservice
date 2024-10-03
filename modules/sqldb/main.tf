# SQL Server
resource "azurerm_sql_server" "main" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_server_admin_login
  administrator_login_password = var.sql_server_admin_password
}

# SQL Database
resource "azurerm_sql_database" "main" {
  name                = var.database_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  server_name         = azurerm_sql_server.main.name
  edition             = "Standard"
  requested_service_objective_name = var.service_objective
}