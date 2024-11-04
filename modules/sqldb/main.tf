resource "azurerm_mssql_server" "dbserver" {
  name                         = var.DBSERVER_NAME
  resource_group_name          = var.RESOURCE_GROUP_NAME
  location                     = var.LOCATION
  version                      = "12.0"
  administrator_login          = var.DBUSERNAME
  administrator_login_password = var.DBPASSWORD
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "dbname" {
  name        = var.DB_NAME
  server_id   = azurerm_mssql_server.dbserver.id
  collation   = var.COLLATION
  sku_name    = "S0"
  max_size_gb = 20
}

resource "azurerm_mssql_firewall_rule" "azureservicefirewall" {
  name             = "allow-azure-service"
  server_id        = azurerm_mssql_server.dbserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_virtual_network_rule" "vnetrule" {
  count = length(var.AKS_SUBNET_SERVICE_ENDPOINT) > 0 ? 1 : 0

  server_id = azurerm_mssql_server.dbserver.id
  subnet_id = var.AKS_SUBNET_ID
  name      = "vnet-rule"
}