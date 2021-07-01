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

