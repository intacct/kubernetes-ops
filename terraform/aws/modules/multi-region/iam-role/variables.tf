variable "name" {
    description = "Name of the service role"
    type        = string
}

variable "custom_iam_policy_arns" {
    description = "List of IAM policies to attach to Service Role"
    #  Right join IAM Policy for service role - target resource to which access is needed eg., S3.  Definition in JSON
    type        = list(string)
    default     = []
}

variable "assume_role_policy" {
    description = "Left join policy for service role - Entity that needs this policy eg., EC2, Glue policy"
    type        = string
    default     = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

variable "policy_attachment_name" {
    description = "Name of policy attachment to service role"
    type        = string
    default     = "custom_audit_policy_attachment"

}

variable "path" {
    description = "Path to the role"
    type        = string
    default     = "/"
}

variable "policy_arn" {
    description = "Left join policy for service role - Entity that needs this policy eg., EC2, Glue policy"
    type        = string
    default     = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

variable "target_policy_name" {
    description = "Right join target policy name"
    type        = string
}

variable "target_policy" {
    description = "Right join target policy eg. s3"
    type       = string
    default    = ""
}
