
output "application_gateway_id" {
  value = module.application_gateway.application_gateway_id
}

output "aks_subnet_id" {
  value = module.vnet.aks_subnet_id
}

output "appgw_subnet_id" {
  value = module.vnet.appgw_subnet_id
}

output "aks_vnet_id" {
  value = module.vnet.aks_vnet_id
}

output "acr_vnet_id" {
  value = module.vnet.acr_vnet_id
}

output "agent_vnet_id" {
  value = module.vnet.agent_vnet_id
}

