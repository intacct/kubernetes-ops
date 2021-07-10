variable "create_bucket" {
  description = "Controls if S3 bucket should be created"
  type        = bool
  # default     = true
}

variable "attach_elb_log_delivery_policy" {
  description = "Controls if S3 bucket should have ELB log delivery policy attached"
  type        = bool
  default     = false
}

variable "attach_policy" {
  description = "Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  type        = bool
  default     = false
}

variable "bucket" {
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = list(any)
  # default     = "intacct-audit"
}

variable "bucket_prefix" {
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  type        = string
  default     = null
}

variable "acl" {
  description = "(Optional) The canned ACL to apply. Defaults to 'private'."
  type        = string
  # default     = "private"
}

variable "policy" {
  description = "(Optional) A valid bucket policy JSON document."
  # Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. 
  #     In this case, please make sure you use the verbose/specific version of the policy. 
  #     For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type    = string
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["arn:aws:iam::374322211295:user/IA-AuditTrailUser"]
      },
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::ia-audittrailbucket",
                    "arn:aws:s3:::ia-audittrailbucket/*"]
    }
  ]
}
EOF
  # "Principal": {
  #   "AWS": ["arn:aws:iam::374322211295:user/IA-AuditTrailUser",
  #           "arn:aws:iam::374322211295:group/Administrators",]
  # },

}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = list(any)
  # default     = {
  #     "Name" = "intacct-audit"
  # }
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error."
  # These objects are not recoverable."
  type    = bool
  default = false
}

variable "acceleration_status" {
  description = "(Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = null
}

variable "auth_profile" {
  description = "(Optional) Specifies the profile that should be used from .aws credentials for authentication to AWS"
  type        = string
  default     = "2auth"
}

/*
variable "region" {
  description = "(Optional) If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee."
  type        = string
}
*/

variable "request_payer" {
  description = "(Optional) Specifies who should bear the cost of Amazon S3 data transfer."
  # Can be either BucketOwner or Requester. 
  #     By default, the owner of the S3 bucket would incur the costs of any data transfer. 
  #     See Requester Pays Buckets developer guide for more information."
  type    = string
  default = null
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  # default     = {
  #     "enabled" = true
  # }
}

variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default     = {}
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = false
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = false
}

# Set it to false to disable s3 object/folder creation
variable "create_s3_objects" {
  type = bool
}

# The name of the object once it is in the bucket
variable "obj_name" {
  description = "Name of the Object/Folder to be created in the bucket"
  type        = any
  default     = []
}

# The path to a file that will be read and uploaded as raw bytes 
# for the object content
variable "obj_source" {
  description = ""
  type        = string
  default     = "/dev/null"
}
