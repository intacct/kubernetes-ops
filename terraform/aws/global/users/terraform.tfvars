#################
# Common vars
# These are common to both USW and EUC regions
#################
auth_profile           = "2auth"
region                 = "us-west-2"
keyname                = "sridhar.krishnamurthy"
pgp_key                = "keybase:skrishnamurthy"
password_len           = 10
require_password_reset = false

##################
# IAM User
##################
user_names = [
  "prerna.sharma",
  "crusu",
  "jeanbaptiste.benoist",
  "sharad.ramachandran",
  "alexandru.talmaciu"
]

service_users = [
  "ia-snowflake",
  "ia-s3-glacier",
]

##################
# IAM Group
##################
group_name = "ia-mandatory-group"

