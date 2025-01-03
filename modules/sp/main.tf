data "azuread_client_config" "current" {}

resource "azuread_application" "main" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]

    lifecycle {
      prevent_destroy = true
    ignore_changes = all
  }
}

resource "azuread_service_principal" "main" {
  client_id               = azuread_application.main.client_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
  description = " This is the service principle for aks project . It is used in devops pipeline as well"

   lifecycle {
    prevent_destroy = true
    ignore_changes = all  # This will ignore all changes to the resource
  }
}


resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.id
  depends_on = [ azuread_application.main ]
}