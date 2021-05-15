acl             = "private"
create_bucket   = true
bucket_name     = ["ia-sail-dev"]
tags            = [{
    "Name" = "ia-sail-dev"
}]
versioning      = {
    "enabled" = true
}
create_s3_objects = false
obj_name          = []
user_name         = [
    "Janarthanan.Rajarajan", 
    "Shilpa.Narasimhamuruthi",
    "Chandrasekhar.Punji",
    "abhijit.kumar"
]
pgp_key           = "keybase:skrishnamurthy"
password_len      = 10
require_password_reset = false
group_name        = "IA-sail"
policy_name       = "IA-sailUserAccess"
policy_path       = "/"
role_name         = "IA-sailServiceRole"
role_path         = "/"
role_policy_name  = "IA-sailServiceRoleAccess"
self_manage       = true

region            = "us-west-2"
auth_profile      = "2auth"
keyname           = "sridhar.krishnamurthy"






