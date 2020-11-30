#################
# Common vars
# These are common to both USW and EUC regions
#################
variable "auth_profile" { default = "2auth" }
variable "region" { default = "us-west-2" }
variable "keyname" { default = "sridhar.krishnamurthy" }
variable "pgp_key" { default = "keybase:kaysree" }
variable "password_len" { default = 10 }
variable "require_password_reset" { default = false }
# variable "acl" { default = "private" }

##################
# IAM User
##################
variable "user_names" { 
  default = [
    "andrei.florea",
    "lorena.rus",
    "marina.vatkina",
    "vcrisan"
  ] 
} 

##################
# IAM Group
##################
variable "group_name" { default = "IA-AuditTrailTesterGroup" }

##################
# IAM Policy
##################
variable "policy_name" { default = "IA-AuditTrailTesterAccess" }
variable "policy_path" { default = "/" }

##################
# Service Role
##################
# variable "role_name" { default = "IA-AuditTrailServiceRole" }
# variable "role_path" { default = "/" }
# variable "role_policy_name" { default = "IA-AuditTrailServiceRoleAccess" }


