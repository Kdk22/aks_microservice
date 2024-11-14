// Output for azuread_application
output "application_id" {
  value = azuread_application.main.id 
}

output "application_object_id" {
  value = azuread_application.main.object_id
}

output "application_display_name" {
  value = azuread_application.main.display_name
}

output "service_principal_application_id" {
  value = azuread_application.main.client_id
}
#Ah, you're right. In newer versions of the Azure AD provider, it's client_id instead of application_id
# inside the azure cloud for permission we use object id but outside cloud like azure devops and other application we use client id (old application id)
// Output for azuread_service_principal
output "service_principal_id" {
  value = azuread_service_principal.main.id
}
// this sends url 


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