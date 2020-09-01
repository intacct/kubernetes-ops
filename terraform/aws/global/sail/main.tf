provider "aws" {
  profile = var.auth_profile
  region  = var.region
}

module "iam_policy" {
  source  = "../../modules/multi-region/iam-policy"
  # version = "~> 2.0"

  name        = var.policy_name
  path        = var.policy_path
  description = "Provides full access to IA-AuditTrail bucket via the AWS Management Console"
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions   = [
      "s3:ListAllMyBuckets",
      "s3:HeadBucket"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions   = [
      "s3:GetAccessPoint",
      "s3:GetLifecycleConfiguration",
      "s3:GetBucketTagging",
      "s3:GetInventoryConfiguration",
      "s3:GetObjectVersionTagging",
      "s3:ListBucketVersions",
      "s3:GetBucketLogging",
      "s3:RestoreObject",
      "s3:ListBucket",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketPolicy",
      "s3:GetObjectVersionTorrent",
      "s3:GetObjectAcl",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketRequestPayment",
      "s3:GetAccessPointPolicyStatus",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectTagging",
      "s3:GetMetricsConfiguration",
      "s3:HeadBucket",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:ListBucketMultipartUploads",
      "s3:GetObjectRetention",
      "s3:GetBucketWebsite",
      "s3:ListAccessPoints",
      "s3:ListJobs",
      "s3:PutObjectLegalHold",
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetObjectLegalHold",
      "s3:GetBucketNotification",
      "s3:GetReplicationConfiguration",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectTorrent",
      "s3:GetAccountPublicAccessBlock",
      "s3:ListAllMyBuckets",
      "s3:DescribeJob",
      "s3:GetBucketCORS",
      "s3:GetAnalyticsConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetBucketLocation",
      "s3:GetAccessPointPolicy",
      "s3:GetObjectVersion",
      "s3:AbortMultipartUpload"
    ]
    effect    = "Allow"
    resources = [
      module.s3_module.this_s3_bucket_arn, 
      format("%s%s", module.s3_module.this_s3_bucket_arn,"/*"),
      "arn:aws:s3:::dev-cloud-storage",
      "arn:aws:s3:::dev-cloud-storage/*"
    ]
  }
}

module "iam_user" {
  source                  = "../../modules/multi-region/iam-user"
  name                    = var.user_name
  force_destroy           = true
  pgp_key                 = var.pgp_key
  password_length         = var.password_len
  password_reset_required = false
  create_iam_user_login_profile = true
  create_iam_access_key = true
  upload_iam_user_ssh_key = false
}

module "iam_group" {
  source                            = "../../modules/multi-region/iam-group"
  # version = "~> 2.0"
  name                              = var.group_name
  group_users                       = module.iam_user.this_iam_user_name
  attach_iam_self_management_policy = var.self_manage
  custom_group_policy_arns          = [
    # "arn:aws:iam::aws:policy/AdministratorAccess",
    module.iam_policy.arn
  ]
}

module "s3_module" {
    source            = "../../modules/multi-region/s3-bucket"
    create_bucket     = var.create_bucket
    bucket            = var.bucket_name
    acl               = var.acl
    tags              = var.tags
    versioning        = var.versioning
    create_s3_objects  = var.create_s3_objects
    obj_name          = var.obj_name
}

data "aws_iam_policy_document" "service-role-s3-policy" {
  statement {
    actions   = [
      # "s3:*"
      "s3:GetAccessPoint",
      "s3:GetLifecycleConfiguration",
      "s3:GetBucketTagging",
      "s3:GetInventoryConfiguration",
      "s3:GetObjectVersionTagging",
      "s3:ListBucketVersions",
      "s3:GetBucketLogging",
      "s3:RestoreObject",
      "s3:ListBucket",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketPolicy",
      "s3:GetObjectVersionTorrent",
      "s3:GetObjectAcl",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketRequestPayment",
      "s3:GetAccessPointPolicyStatus",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectTagging",
      "s3:GetMetricsConfiguration",
      "s3:HeadBucket",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:ListBucketMultipartUploads",
      "s3:GetObjectRetention",
      "s3:GetBucketWebsite",
      "s3:ListAccessPoints",
      "s3:ListJobs",
      "s3:PutObjectLegalHold",
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetObjectLegalHold",
      "s3:GetBucketNotification",
      "s3:GetReplicationConfiguration",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectTorrent",
      "s3:GetAccountPublicAccessBlock",
      "s3:ListAllMyBuckets",
      "s3:DescribeJob",
      "s3:GetBucketCORS",
      "s3:GetAnalyticsConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetBucketLocation",
      "s3:GetAccessPointPolicy",
      "s3:GetObjectVersion",
      "s3:AbortMultipartUpload"
    ]
    effect    = "Allow"
    resources = [
      module.s3_module.this_s3_bucket_arn,
      format("%s%s",module.s3_module.this_s3_bucket_arn,"/*")
    ]
  }
}

module "iam_role" {
  source = "../../modules/multi-region/iam-role"
  # version = "~> 2.0"
  
  name  = var.role_name
  path  = var.role_path
  # custom_iam_policy_arns = [
  #   module.iam_policy_glue.arn
  # ]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  target_policy_name = var.role_policy_name
  target_policy = data.aws_iam_policy_document.service-role-s3-policy.json

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# terraform {
#   required_version = ">= 0.10.3" # introduction of Local Values configuration language feature
# }


output "s3_bucket_arn" {
  value = module.s3_module.this_s3_bucket_arn
}

output "output_module" {
  value = module.iam_user
}

output "output_s3" {
  value = module.s3_module
}

output "password" {
  value = module.iam_user.this_iam_user_login_profile_encrypted_password
}

output "output_role" {
  value = module.iam_role
}

