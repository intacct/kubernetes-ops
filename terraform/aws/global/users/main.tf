provider "aws" {
  profile = var.auth_profile
  region  = var.region
}

/* terraform {
  required_providers {
    version = "~> 3.47.0"
  }
} */

module "iam_user" {
  source                  = "../../modules/multi-region/iam-user"
  name                    = var.user_names
  force_destroy           = true
  create_user             = true
  create_iam_user_login_profile = true
  create_iam_access_key   = true

  pgp_key                 = var.pgp_key
  password_length         = var.password_len
  password_reset_required = false
}

module "iam_group" {
    source = "../../modules/multi-region/iam-group"
    create_group = true
    name = var.group_name
    group_users = module.iam_user.this_iam_user_name
    custom_group_policy_arns = [
        "arn:aws:iam::374322211295:policy/Force_MFA_For_All_IAM_Users",
        "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
        "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    ]
    attach_iam_self_management_policy = true
}


output "output_iam_user_name" {
    value = module.iam_user.this_iam_user_name
}
output "output_iam_user_encrypted_password" {
    value = module.iam_user.this_iam_user_login_profile_encrypted_password
}
output "output_iam_user_encrypted_password_cmd" {
    value = module.iam_user.keybase_password_decrypt_command
}
output "output_iam_user_access_key" {
    value = module.iam_user.this_iam_access_key_id
}
output "output_iam_user_encrypted_secred" {
    value = module.iam_user.this_iam_access_key_encrypted_secret
}
# output "output_iam_user_secret_key_cmd" {
#     value = module.iam_user.keybase_secret_key_decrypt_command
# }
