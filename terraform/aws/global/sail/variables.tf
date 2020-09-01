#################
# Common vars
# These are common to both USW and EUC regions
#################
variable "auth_profile" { type = string }
variable "acl" { type = string }
variable "create_bucket" {
  description = "Set it false if bucket creation should be disabled"
  type        = bool
}
variable "bucket_name" { type = string }
variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = map(string)
}
variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
}
variable "obj_name" {
  description = "Name of the object/folder to be created inside bucket"
  type        = list
}
variable "create_s3_objects" {
  description = "Set it to true if s3 objects/folders need to be created"
  type        = bool
}

##################
# IAM User
##################
variable "user_name" { type = list(string) } 
variable "pgp_key" { type = string }
variable "password_len" { type = number }
variable "require_password_reset" { type = bool }

##################
# IAM Group
##################u
variable "group_name" { type = string }
variable "self_manage" { type = bool }

##################
# IAM Policy
##################
variable "policy_name" { type = string }
variable "policy_path" { type = string }

##################
# Service Role
##################
variable "role_name" { type = string }
variable "role_path" { type = string }
variable "role_policy_name" { type = string }



#################
# USW specific vars
#################
variable "region" { type = string }
variable "keyname" { type = string }

