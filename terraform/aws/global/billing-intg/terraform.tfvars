#################
# Common vars
# These are common to both USW and EUC regions
#################
auth_profile = "2auth"
region = "us-west-2" 
keyname = "sridhar.krishnamurthy" 
pgp_key = "keybase:skrishnamurthy" 
password_len = 10 
require_password_reset = false 
# variable "acl" { default = "private" }

##################
# IAM User
##################
user_names = [
    "prerna.sharma",
    "crusu",
    "jeanbaptiste.benoist",
    "ia-snowflake"
  ] 

##################
# IAM Group
##################
group_name = "ia-billing-intgeration" 

##################
# IAM Policy
##################
policy_name = "ia-billing-integration"
policy_path = "/"

# ----------------------------------------------------------------------------------------------------------------------
# Service Role 
# ----------------------------------------------------------------------------------------------------------------------
role_name         = "ia-billing-integration"
role_path         = "/"
role_policy_name  = "ia-billing-integration-role"
self_manage       = true

# ----------------------------------------------------------------------------------------------------------------------
# S3 
# ----------------------------------------------------------------------------------------------------------------------
create_bucket = true
bucket_name = ["ia-billing-integration"]
bucket_acl = "private"
bucket_tags = [
  {
      "Name" = "ia-billing-integration"
  }
]
bucket_versioning = { "enabled" = true }
create_s3_objects = false
obj_names = []

