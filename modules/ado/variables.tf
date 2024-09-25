# inside variables:
variable "ado_github_id" {
  type = string
  description = "This is already created github id"
  default     = "Kdk22/aks_microservice"
}

variable "ado_pipeline_yaml_path_1" {
  type        = string
  description = "Path to the yaml for the first pipeline"
  default     = "azure-pipelines.yaml"
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}
variable "project_name" {
  type = string
  description = "Project Name"
  
}

# variable "ado_org_service_url" {
#   type = string
#   description = "Url"
  
# }