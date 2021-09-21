variable helm_version {
  type        = string
  default     = "8.3.0"
  description = "Helm chart version"
}

variable verify {
  type        = bool
  default     = false
  description = "Verify the helm download"
}

variable "create_namespace" {
  type = bool
  default = true
  description = "Create namespace if it does not exist"
}

variable namespace {
  type        = string
  default     = "kubernetes-external-secrets"
  description = "Namespace to install in"
}

variable chart_name {
  type        = string
  default     = "kubernetes-external-secrets"
  description = "Name to set the helm deployment to"
}

variable helm_values {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}

variable "environment_name" {
  type = string
  default = "env"
  description = "An environment name to attach to some resources.  Optional only needed if you are going to create more than one of these items in an AWS account"
}