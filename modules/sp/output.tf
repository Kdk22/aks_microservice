// Output for azuread_application
output "application_id" {
  value = azuread_application.main.application_id
}

output "application_object_id" {
  value = azuread_application.main.object_id
}

output "application_display_name" {
  value = azuread_application.main.display_name
}

// Output for azuread_service_principal
output "service_principal_id" {
  value = azuread_service_principal.main.id
}

output "service_principal_application_id" {
  value = azuread_service_principal.main.application_id
}

output "service_principal_object_id" {
  value = azuread_service_principal.main.object_id
}

output "service_principal_display_name" {
  value = azuread_service_principal.main.display_name
}

// Output for azuread_service_principal_password
output "service_principal_password_id" {
  value = azuread_service_principal_password.main.id
}

output "service_principal_password_value" {
  value = azuread_service_principal_password.main.value
}