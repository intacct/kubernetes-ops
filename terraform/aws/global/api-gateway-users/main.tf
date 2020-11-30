provider "aws" {
  profile = var.auth_profile
  region  = var.region
}

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
output "output_iam_user_secret_key_cmd" {
    value = module.iam_user.keybase_secret_key_decrypt_command
}

module "iam_group" {
    source = "../../modules/multi-region/iam-group"
    create_group = true
    name = "IA-ElasticContainerRepository"
    group_users = module.iam_user.this_iam_user_name
    custom_group_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
        # module.iam_policy.arn
    ]
    attach_iam_self_management_policy = true
}

# module "iam_policy" {
#   source  = "../../modules/multi-region/iam-policy"
# #   version = "~> 2.0"

#   name        = "IA-AuditTrailTesterPolicy"
#   path        = "/"
#   description = "Provides necessary access for IA-AuditTrail Testers"
#   policy = data.aws_iam_policy_document.policy.json
# }

# data "aws_iam_policy_document" "policy" {
#   statement {
#     actions = [
#         "s3:GetAccessPoint",
#         "s3:PutAccountPublicAccessBlock",
#         "s3:GetAccountPublicAccessBlock",
#         "s3:ListAllMyBuckets",
#         "s3:ListAccessPoints",
#         "s3:ListJobs",
#         "s3:CreateJob",
#         "s3:HeadBucket"
#     ]
#     effect   = "Allow"
#     resources = ["*"]
#   }
#   statement {
#     actions = ["s3:*"]
#     effect = "Allow"
#     resources = [
#                 "arn:aws:s3:::ia-audittrailbucket",
#                 "arn:aws:s3:::ia-audittrailbucket/*"
#     ]
#   }
# }
