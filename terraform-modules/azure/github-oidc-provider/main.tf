locals {
  base_name           = "github-actions-oidc"
  ## This should match the name of the service account created by helm chart
  service_account_name = "${local.base_name}-${var.environment_name}"
}

data "azurerm_subscription" "current" {
}

################################################
## Setting up the Azure OIDC Federation
################################################

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}

## Azure AD application that represents the app
resource "azuread_application" "app" {
  display_name = "${local.base_name}-${var.environment_name}"

  # Based on: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment#example-usage
  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
      type = "Role"
    }

    ## Access to create Azure Active Directory Groups
    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
      type = "Role"
    }
  }  
  web {
    logout_url    = var.logout_url
    redirect_uris = var.redirect_uris

    implicit_grant {
      access_token_issuance_enabled = var.access_token_issuance_enabled
      id_token_issuance_enabled     = var.id_token_issuance_enabled
    }  
  }
}

resource "azuread_service_principal" "app" {
  application_id = azuread_application.app.application_id
}

resource "azuread_app_role_assignment" "this" {
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
  principal_object_id = azuread_service_principal.app.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.app.id
}

## Azure AD federated identity used to federate kubernetes with Azure AD
resource "azuread_application_federated_identity_credential" "app" {
  count                 = length(var.federated_identity_credential)
  application_object_id = azuread_application.app.object_id
  display_name          = "fed-identity-${local.base_name}-${var.environment_name}-${var.federated_identity_credential[count.index].name_postfix}"
  description           = "The federated identity used to federate K8s with Azure AD with the app service running in k8s ${local.base_name} ${var.environment_name}"
  # Doc for the `audiences` string: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure#adding-the-federated-credentials-to-azure
  audiences             = var.federated_identity_credential[count.index].audiences
  issuer                = var.federated_identity_credential[count.index].issuer
  # Doc for the `subject` string: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#configuring-the-subject-in-your-cloud-provider
  subject               = var.federated_identity_credential[count.index].subject
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "this" {
#   name                 = azurerm_role_definition.example.role_definition_id
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = var.role_definition_name
  principal_id         = azuread_service_principal.app.id
}