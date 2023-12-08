variable helm_version {
  type        = string
  default     = "1.3.0"
  description = "Helm chart version"
}
variable verify {
  type        = bool
  default     = false
  description = "Verify the helm download"
}

variable namespace {
  type        = string
  default     = "awx"
  description = "Namespace to install in"
}
variable chart_name {
  type        = string
  default     = "awx"
  description = "Name to set the helm deployment to"
}
variable helm_values {
  type        = string
  default     = ""
  description = "Additional helm values to pass in.  These values would override the default in this module."
}
variable "eks_cluster_id" {
  type        = string
  default     = ""
  description = "EKS cluster ID"
}