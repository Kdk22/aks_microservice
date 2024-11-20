## This is a private acr
### Retrive ACR Vnet Id
# data "azurerm_virtual_network" "acr-vnet" {
#   name                = "acr-vnet"
#   resource_group_name = var.RESOURCE_GROUP_NAME
# }
# data "azurerm_virtual_network" "agent-vnet" {
#   name                = "agent-vnet"
#   resource_group_name = var.RESOURCE_GROUP_NAME
# }
# data "azurerm_virtual_network" "aks-vnet" {
#   name                = "aks-vnet"
#   resource_group_name = var.RESOURCE_GROUP_NAME
# }
# Create azure container registry
resource "azurerm_container_registry" "acr" {
  name                          = var.PRIVATE_ACR_NAME
  resource_group_name           = var.RESOURCE_GROUP_NAME
  location                      = var.LOCATION
  sku                           = var.ACR_SKU
  admin_enabled                 = false
  public_network_access_enabled = false
# becasue here we are creating private acr so false


  network_rule_set {
    default_action = "Deny"

    ip_rule {
      action   = "Allow"
      ip_range = "13.0.0.0/16"
    }
  }
}


# Create azure private DNS ZONE
resource "azurerm_private_dns_zone" "acr-dns-zone" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.RESOURCE_GROUP_NAME

}
# Create azure private endpoint
# this code snippet creates a secure 
# private connection from a specific subnet within your virtual network to your Azure Container Registry.
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "${var.PRIVATE_ACR_NAME}-private-endpoint"
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  subnet_id           = var.ACR_SUBNET_ID 
  #tags                = var.tags
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr-dns-zone.id]
  }

  private_service_connection {
    name                           = "${var.PRIVATE_ACR_NAME}-service-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}

# creates a virtual network link for a private DNS zone.
resource "azurerm_private_dns_zone_virtual_network_link" "acr-vnet-link" {
  name                  = "acr-vnet-link"
  resource_group_name   = var.RESOURCE_GROUP_NAME
  private_dns_zone_name = azurerm_private_dns_zone.acr-dns-zone.name
  virtual_network_id    = var.ACR_VNET_ID
  depends_on = [azurerm_private_dns_zone.acr-dns-zone]
}

# data.azurerm_virtual_network.acr-vnet.id = var.ACR_VNET_ID

# ### Retrive ACR subnet Id
# data "azurerm_subnet" "acr-subnet" {
#   name                 = "acr-subnet"
#   virtual_network_name = "acr-vnet"
#   resource_group_name  = azurerm_container_registry.acr.resource_group_name
# }

##### Create Virtual network link in private dns zone

resource "azurerm_private_dns_zone_virtual_network_link" "aks-vnet-link" {
  name                  = "aks-vnet-link"
  resource_group_name   = azurerm_container_registry.acr.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr-dns-zone.name
  virtual_network_id    = var.AKS_VNET_ID

  # data.azurerm_virtual_network.aks-vnet.id = AKS_VNET_ID 
}
resource "azurerm_private_dns_zone_virtual_network_link" "agent-vnet-link" {
  name                  = "agent-vnet-link"
  resource_group_name   = azurerm_container_registry.acr.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr-dns-zone.name
  virtual_network_id    = var.AGENT_VNET_ID
}

# data.azurerm_virtual_network.agent-vnet.id = AGENT_VNET_ID


# #### Fetching the service principle object Id so we can add role assignment on ACR ###
# data "azuread_service_principal" "acr-access" {
#   display_name = "acr-access"
# }

resource "azurerm_role_assignment" "Acrpush_role" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = var.SERVICE_PRINCIPAL_OBJECT_ID
}