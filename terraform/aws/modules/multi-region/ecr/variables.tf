variable "create_repository" {
  type = bool
  default = true
  description = "If true, create the named repository"
}

variable "repository_names" {
  type        = list(string)
  description = "Names of the repository"
}

variable "attach_lifecycle_policy" {
  default     = false
  type        = bool
  description = "If true, an ECR lifecycle policy will be attached"
}

variable "lifecycle_policy" {
  type        = map(string)
  description = "Contents of the ECR lifecycle policy"
  default     = {}
}

variable "scan_on_push" {
  description = "If true, enable scanning of pushed images on repo for vulnerabilities"
  type        = bool
  default     = true
}