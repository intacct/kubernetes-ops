#################
# Common vars
# These are common to both USW and EUC regions
#################
variable "auth_profile" { }
variable "region" { }
variable "keyname" { }
variable "pgp_key" { }
variable "password_len" {  }
variable "require_password_reset" { }
# variable "acl" { default = "private" }

##################
# IAM User
##################
variable "user_names" { } 

##################
# IAM Group
##################
variable "group_name" { }

##################
# IAM Policy
##################
variable "policy_name" { }
variable "policy_path" { }

# ----------------------------------------------------------------------------------------------------------------------
# Service Role 
# ----------------------------------------------------------------------------------------------------------------------
variable role_name        { }
variable role_path        { }
variable role_policy_name { }
variable self_manage      { }


# ----------------------------------------------------------------------------------------------------------------------
# S3 Bucket
# ----------------------------------------------------------------------------------------------------------------------
variable "create_bucket" { }
variable "bucket_name" { }
variable "bucket_acl" { }
variable "bucket_tags" { }
variable "bucket_versioning" { }
variable "create_s3_objects" { }
variable "obj_names" { }



