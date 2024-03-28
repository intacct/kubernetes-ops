variable "environment_name" {
  type = string
  default = "dev"
  description = "An arbitrary environment name"
}

variable "oidc_k8s_issuer_url" {
  type        = string
  default     = ""
  description = "The OIDC k8s issuer url.  If using the kubernetes-ops/azure creation it would be in the AKS output."
}

variable "role_definition_name" {
  type        = string
  default     = "Owner"
  description = "The pre-defined azure role to use; Contributor, Owner, etc.  Owners is needed b/c it will need to assign roles and even the Contributor role does not have this access."
}

variable "azure_resource_group_name" {
  type        = string
  default     = null
  description = "The Azure resource group"
}

variable "logout_url" {
  type        = string
  default     = null
  description = "The URL that will be used by Microsoft's authorization service to sign out a user using front-channel, back-channel or SAML logout protocols."
}

variable "redirect_uris" {
  type        = list(string)
  default     = null
  description = "A set of URLs where user tokens are sent for sign-in"
}

variable "access_token_issuance_enabled" {
  type        = bool
  default     = false
}     
variable "id_token_issuance_enabled" {
  type        = bool
  default     = false
}  
variable "federated_identity_credential" {
  type        = any
  description = "The Azure federated_identity_credential"
  default     = [
    {
      name_postfix = "pull_request"
      description  = "The federated identity used to federate K8s with Azure AD with the app service running in k8s"
      audiences    = ["api://AzureADTokenExchange"]
      issuer       = "https://token.actions.githubusercontent.com"
      subject      = "repo:ManagedKube/kubernetes-ops:pull_request" # repo:<github org>/<github repo name>:<action>
    },
    {
      name_postfix = "master"
      description  = "The federated identity used to federate K8s with Azure AD with the app service running in k8s"
      audiences    = ["api://AzureADTokenExchange"]
      issuer       = "https://token.actions.githubusercontent.com"
      subject      = "repo:ManagedKube/kubernetes-ops:ref:refs/heads/master"
    },
  ]
}