#################
# Common vars
# These are common to both USW and EUC regions
#################
auth_profile = "2auth"
region = "us-west-2" 
keyname = "sridhar.krishnamurthy" 
pgp_key = "keybase:kaysree" 
password_len = 10 
require_password_reset = false 
# variable "acl" { default = "private" }

##################
# IAM User
##################
user_names = [
    "vcrisan",
    "RicardoFilipe.Santos"
  ] 

##################
# IAM Group
##################
group_name = "IA-ElasticContainerRepository" 

##################
# IAM Policy
##################
# variable "policy_name" { default = "IA-AuditTrailTesterAccess" }
# variable "policy_path" { default = "/" }



