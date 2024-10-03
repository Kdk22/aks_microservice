# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false  
}
 
 resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Aks-project/sshPublicKeys@2024-09-26"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_public_key" {
  type        = "Aks-project/sshPublicKeys@2024-09-26"
  name      = random_pet.ssh_key_name.id
  location              = var.location
  parent_id = var.rg_id
}


resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                  = "aks-cluster"
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "${var.resource_group_name}-cluster"           
  kubernetes_version    =  data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"
  
  
  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard_DS2_v2"
    zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
     } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
   } 
  }

  service_principal  {
    client_id = var.client_id
    client_secret = var.client_secret
  }



  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
        # key_data = file(var.ssh_public_key) used this when i created ssh from cmd
        key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }

    
  }