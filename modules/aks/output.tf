output "fqdn" {
  value = azurerm_kubernetes_cluster.akscluster.fqdn
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.akscluster.kube_config_raw
  sensitive = true
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.akscluster.name
}

output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.akscluster.id
}

output "dns_prefix" {
  value = azurerm_kubernetes_cluster.akscluster.dns_prefix
}