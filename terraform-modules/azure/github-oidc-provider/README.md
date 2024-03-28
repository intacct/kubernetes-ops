# terraform-azure-github-oidc-provider
Github Action OIDC Setup for Azure

# Creating a service principal with a Federated Credential to use OIDC based authentication
It is essentially following these instructions but via Terraform: https://github.com/marketplace/actions/azure-login#configure-a-service-principal-with-a-federated-credential-to-use-oidc-based-authentication

# Azure permissions required to run this Terraform
This Terraform will have to be ran locally by a user with sufficient permissions to create an Azure App Registration.  Instructions/documentation on the permissions needed are here: https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#permissions-required-for-registering-an-app

The user that is running this terraform will also need to have the `Application Administrator`
added to the Active Directoy user:
* https://learn.microsoft.com/en-us/azure/active-directory/roles/permissions-reference

It actually looks like you need `Global Administrator` permission for the user to be able to 
successfully run this and in particular to perform the TF `app_role_assignment`:
* https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment#api-permissions
* This was the only resource that needed the `Global Administrator` permissions

# Gather info for the Github Actions inputs
These items will be required for the Github Actions inputs:
* https://github.com/marketplace/actions/azure-login#sample-workflow-that-uses-azure-login-action-using-oidc-to-run-az-cli-linux

For the following values:
* client-id
* tenant-id
* subscription-id

## client-id and tenant-id
* After creation of Azure app (after running this Terraform)
* Go to the Azure web console
* Go to "App registration"
* Click on the "All application" tab
* Click on the app that was created.  Default name is: github-actions-oidc-dev

Values: 
* client-id is the "Application (client) ID" value
* tenant-id is the "Directory (tenant) ID" value

## subscription-id
Can be retrieved from the Azure web console by searching "subscription" and selecting
the subscription you are using.

# Viewing resources created in the Azure console

## App Registration
Location: Azure Console -> App Registration -> All applications

# The guide to follow on how to use Azure OIDC Federated auth with Terraform
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_oidc

There are some nuance to it like you have to specify the `use_oidc=true` key/val in the provider and
backend.

# ACTION REQUIRED AFTER APPLYING THIS
Unfortunately, there is a manual process after applying this to finish granting access to this new
github action azure application that has federated OIDC access to your Azure account.  You will need
to press the button to grant the Azure Application access.

In the Azure Web Console:
* Search for: App registration
* Go under the All application tab
* Click on the application name (for example: github-actions-oidc-dev)
* On the left under Manage click on API permissions

This Terraform created this App registration and the permissions but it requires a human user to click on
the "Grant admin consent for <subscription name>" button in the middle of the page.