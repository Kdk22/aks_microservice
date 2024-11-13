

# output "secret_value" {
#   value = data.azurerm_key_vault_secret.example.value
# }
terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
    }
  }
}


resource "azuredevops_project" "project" {
  name               = var.project_name
  description        = "This is AKS Project"
  visibility         = "private"
  version_control    = "Git"   # This will always be Git for me
  work_item_template = "Agile" # Not sure if this matters, check back later

  features = {
    # Only enable pipelines for now
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "pipelines"    = "enabled"
  }
}

resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "GitHub Connection"

  auth_personal {
    personal_access_token = var.github_pat
  }

}

resource "azuredevops_agent_pool" "agent-pool" {
  name           = "AKS-Agent-Pool"
  auto_provision = false
  auto_update    = false
}

resource "azuredevops_agent_queue" "agent-pool-queue" {
  project_id    = azuredevops_project.project.id
  agent_pool_id = azuredevops_agent_pool.agent-pool.id

  depends_on = [ azuredevops_agent_pool.agent-pool, azuredevops_project.project ]
}




resource "azuredevops_build_definition" "pipeline_1" {

  project_id = azuredevops_project.project.id
  name       = "AKS-Terraform-Pipeline"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = var.ado_github_id
    branch_name           = "main"
    yml_path              = var.ado_pipeline_yaml_path_1
    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  }
  

}

resource "azuredevops_pipeline_authorization" "example" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.example.id
  type        = "endpoint"
  # pipeline_id = azuredevops_build_definition.pipeline_1.id
  # if no pipeline is provided it's all pipelines

  depends_on = [azuredevops_project.project, azuredevops_serviceendpoint_azurerm.example ]
}



resource "azuredevops_serviceendpoint_azurerm" "example" {
  project_id                             = azuredevops_project.project.id
  service_endpoint_name                  = "AKS-TERRA-AzureRM"
  description                            = "Managed by Terraform"
  service_endpoint_authentication_scheme = "ServicePrincipal"
  credentials {
    serviceprincipalid  = var.service_principal_id
    serviceprincipalkey = var.service_principal_secret
  }
  azurerm_spn_tenantid      = var.spn_tenant_id
  azurerm_subscription_id   = var.spn_subscription_id
  azurerm_subscription_name = var.subscription_name
}






