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
    "sharad.ramachandran",
  ] 

##################
# IAM Group
##################
group_name = "ia-billing-view" 

##################
# IAM Policy
##################
policy_name = "ia-billing-view"
policy_path = "/"

# ----------------------------------------------------------------------------------------------------------------------
# Service Role 
# ----------------------------------------------------------------------------------------------------------------------
role_name         = "ia-billing-view"
role_path         = "/"
role_policy_name  = "ia-billing-view-role"
self_manage       = true

# ----------------------------------------------------------------------------------------------------------------------
# S3 
# ----------------------------------------------------------------------------------------------------------------------
create_bucket = false
bucket_name = []
bucket_acl = "private"
bucket_tags = []
bucket_versioning = {}
create_s3_objects = false
obj_names = []

