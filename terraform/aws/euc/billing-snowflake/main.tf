provider "aws" {
  profile = var.auth_profile
  region  = var.region
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

module "s3_module" {
    source            = "../../modules/multi-region/s3-bucket"
    create_bucket     = var.create_bucket
    bucket            = var.bucket_name
    acl               = var.bucket_acl
    tags              = var.bucket_tags
    versioning        = var.bucket_versioning
    create_s3_objects  = var.create_s3_objects
    obj_name          = var.obj_names
    # attach_policy = true
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
      "s3:ListAllMyBuckets",
      "s3:HeadBucket"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions   = [
      "s3:*",
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
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    effect    = "Allow"
    resources = [
      module.s3_module.this_s3_bucket_arns[0],
      format("%s%s", module.s3_module.this_s3_bucket_arns[0],"/*")
    ]
  }
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
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    effect    = "Allow"
    resources = [
      module.s3_module.this_s3_bucket_arns[0],
      format("%s%s", module.s3_module.this_s3_bucket_arns[0],"/*")
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

