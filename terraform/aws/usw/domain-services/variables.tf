
#################
# Common vars
# These are common to both USW and EUC regions
#################
variable "auth_profile" { }
variable "region" { }
# variable "keyname" { }
# variable "pgp_key" { }
# variable "password_len" {  }
# variable "require_password_reset" { }
# variable "acl" { default = "private" }

##################
# Elastic Container Repository
##################
variable "create_repository" { }
variable "repository_names" { type = list(string) }
variable "attach_lifecycle_policy" { }

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
