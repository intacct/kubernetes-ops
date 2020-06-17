variable "create_repository" {
  type = bool
  default = true
  desription = "If true, create the named repository"
}

variable "repository_name" {
  type        = string
  description = "Name of the repository"
}

variable "attach_lifecycle_policy" {
  default     = false
  type        = bool
  description = "If true, an ECR lifecycle policy will be attached"
}

variable "lifecycle_policy" {
  type        = string
  description = "Contents of the ECR lifecycle policy"
  default     = ""
}