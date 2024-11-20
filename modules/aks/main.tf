

# Datasource to get Latest Azure AKS latest Version

data "azurerm_kubernetes_service_versions" "current" {
  location = var.LOCATION
  include_preview = false  
}


### DNS zone
# 
resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.centralindia.azmk8s.io"
  resource_group_name = var.RESOURCE_GROUP_NAME
}

# Integraing private endpoint with dns zone. Here is vnet link to private dns
# zone for internal communication within the AKS cluster
resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  name                  = "pdzvnl-aks"
  resource_group_name   = var.RESOURCE_GROUP_NAME
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = var.AKS_VNET_ID #data.azurerm_virtual_network.aks-vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks-acr" {
  name                  = "pdzvnl-aksacr"
  resource_group_name   = var.RESOURCE_GROUP_NAME
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = var.ACR_VNET_ID #data.azurerm_virtual_network.acr-vnet.id
}
resource "azurerm_private_dns_zone_virtual_network_link" "aks-agent" {
  name                  = "pdzvnl-aksagent"
  resource_group_name   = var.RESOURCE_GROUP_NAME
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = var.AGENT_VNET_ID #data.azurerm_virtual_network.agent-vnet.id
}

### Identity
# provide access for aks to pull image from acr
resource "azurerm_user_assigned_identity" "aks-access" {
  name                = "aks-access"
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
}

### Identity role assignment
#grants the AKS cluster the necessary permissions to manage DNS records within the private DNS zone.
resource "azurerm_role_assignment" "dns_contributor" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-access.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.AKS_VNET_ID
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-access.principal_id
}

 # role to pull the image
resource "azurerm_role_assignment" "Aks-AcrPull" {
  scope                = var.ACR_ID
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.akscluster.kubelet_identity.0.object_id

  depends_on = [ azurerm_kubernetes_cluster.akscluster ]
}
 resource "azurerm_role_assignment" "app-gw-contributor" {
   scope                = var.APPGATEWAY_ID
   role_definition_name = "Contributor"
   principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  depends_on = [ azurerm_kubernetes_cluster.akscluster ]
 }
 resource "azurerm_role_assignment" "appgw-contributor" {
   scope                = var.APPGW_SUBNET_ID
   role_definition_name = "Network Contributor"
   principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  depends_on = [ azurerm_kubernetes_cluster.akscluster ]
 }

### AKS cluster creation
resource "azurerm_kubernetes_cluster" "akscluster" {
  name                      = var.NAME
  location                  = var.LOCATION
  resource_group_name       = var.RESOURCE_GROUP_NAME
  kubernetes_version        = var.kubernetes_version
  dns_prefix                = var.DNS_PREFIX
  private_cluster_enabled   = var.private_cluster_enabled
  #automatic_channel_upgrade = var.automatic_channel_upgrade
  sku_tier                  = var.sku_tier
  azure_policy_enabled      = var.azure_policy_enabled
  private_dns_zone_id       = azurerm_private_dns_zone.aks.id

  default_node_pool {
    name                   = var.default_node_pool_name
    vm_size                = var.default_node_pool_vm_size
    vnet_subnet_id         = var.AKS_SUBNET_ID
    zones                  = var.default_node_pool_availability_zones

    auto_scaling_enabled = var.default_node_pool_auto_scaling_enabled
    max_pods               = var.default_node_pool_max_pods
    max_count              = var.default_node_pool_max_count
    min_count              = var.default_node_pool_min_count
    node_count             = var.default_node_pool_node_count
    os_disk_type           = var.default_node_pool_os_disk_type
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "dev"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
  }
  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks-access.id]
  }

   ingress_application_gateway {
     gateway_id = var.APPGATEWAY_ID
   }
  
  network_profile {
    dns_service_ip    = var.network_dns_service_ip
    network_plugin    = var.network_plugin
    service_cidr      = var.network_service_cidr
    load_balancer_sku = "standard"
  }
  
    depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.dns_contributor
  ]
}





  #  linux_profile {
  #   admin_username = "ubuntu"
  #   ssh_key {
  #       # key_data = file(var.ssh_public_key) used this when i created ssh from cmd
  #       key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
  #   }
  # }


# here we will deploy all pod. Node pool is nothing it's like vm scale set which would be used by aks
  resource "azurerm_kubernetes_cluster_node_pool" "linux101" {
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.akscluster.id
  name                   = var.user_linux_node_pool_name
  mode                   = var.user_node_pool_mode
  vm_size                = var.default_node_pool_vm_size
  vnet_subnet_id         = var.AKS_SUBNET_ID 
  zones                  = var.default_node_pool_availability_zones
  auto_scaling_enabled =  var.default_node_pool_auto_scaling_enabled

  #max_pods               = var.default_node_pool_max_pods
  max_count    = "1"
  min_count    = "1"
  node_count   = var.default_node_pool_node_count
  os_disk_type = var.default_node_pool_os_disk_type
  node_labels = {
    "nodepool-type" = var.user_node_pool_mode
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "user-apps"
  }

}

# using sepreate node pool not using system node pool
# whenever we create aks cluster by defaul it creates
# system node pool and it's not good practice to deploy your application 
# in sytem node pool