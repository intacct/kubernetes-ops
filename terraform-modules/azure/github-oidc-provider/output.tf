output "azuread_application_app_application_id" {
    value = azuread_application.app.application_id
}

output "azuread_service_principal_app_id" {
    value = azuread_service_principal.app.id
}