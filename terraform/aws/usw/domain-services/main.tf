provider "aws" {
  profile = var.auth_profile
  region  = var.region
}

module "ecr-repository" {
  source                  = "../../modules/multi-region/ecr"
  create_repository       = var.create_repository
  repository_names        = var.repository_names
  attach_lifecycle_policy = var.attach_lifecycle_policy
}

module "iam_group" {
    source = "../../modules/multi-region/iam-group"
    create_group = true
    name = var.group_name
    group_users = var.user_names
    custom_group_policy_arns          = [
      module.iam_policy.arn
    ]
    attach_iam_self_management_policy = true
}

module "iam_policy" {
  source  = "../../modules/multi-region/iam-policy"

  name        = var.policy_name
  path        = var.policy_path
  description = "Provides full access to billing-integration bucket via the AWS Management Console"
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions   = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:ecr:us-east-1:374322211295:repository/ia-ds-template"
    ]
  }

}

# module "iam_role" {
#   source = "../../modules/multi-region/iam-role"
#   # version = "~> 2.0"
  
#   name  = var.role_name
#   path  = var.role_path
#   # custom_iam_policy_arns = [
#   #   module.iam_policy_glue.arn
#   # ]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
#   target_policy_name = var.role_policy_name
#   target_policy = data.aws_iam_policy_document.service-role-s3-policy.json

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "glue.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

