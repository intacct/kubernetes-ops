provider "aws" {
  profile = var.auth_profile
  region  = var.region
}

module "iam_policy" {
  source  = "../../modules/multi-region/iam-policy"
  # version = "~> 2.0"

  name        = "IA-AuditTrailUserAccess"
  path        = "/"
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
      "s3:GetObjectVersion"
    ]
    effect    = "Allow"
    # resources = ["*"]
    resources = [module.s3_module.this_s3_bucket_arn, format("%s%s", module.s3_module.this_s3_bucket_arn,"/*")]
  }
}

module "iam_user" {
  source                  = "../../modules/multi-region/iam-user"
  name                    = "IA-AuditTrailUser"
  force_destroy           = true
  pgp_key                 = "keybase:kaysree"
  password_length         = 10
  password_reset_required = false
}

module "iam_group" {
  source                            = "../../modules/multi-region/iam-group"
  # version = "~> 2.0"
  name                              = "IA-AuditTrailUserGroup"
  group_users                       = [
    "IA-AuditTrailUser",
  ]
  attach_iam_self_management_policy = false
  custom_group_policy_arns          = [
    # "arn:aws:iam::aws:policy/AdministratorAccess",
    module.iam_policy.arn
  ]
}

module "s3_module" {
    source            = "../../modules/multi-region/s3-bucket"
    create_bucket     = var.create_bucket
    bucket            = var.bucket
    acl               = var.acl
    tags              = var.tags
    versioning        = var.versioning
    create_s3_objects  = var.create_s3_objects
    obj_name          = var.obj_name
    # attach_policy = true
}

# output "s3_bucket_arn" {
#   value = module.s3_module.this_s3_bucket_arn
# }

output "output_module" {
  value = module.iam_user
}

output "output_s3" {
  value = module.s3_module
}

output "password" {
  value = module.iam_user.this_iam_user_login_profile_encrypted_password
}

# module "iam_policy_glue" {
#   source  = "../../modules/multi-region/iam-policy"
#   # version = "~> 2.0"

#   name        = "IA-AuditTrailServiceRoleAccess"
#   path        = "/"
#   description = "Provides role IA-AuditTrailServiceRole access to IA-AuditTrail bucket"

#   policy = data.aws_iam_policy_document.service-role-s3-policy.json
# }

data "aws_iam_policy_document" "service-role-s3-policy" {
  statement {
    actions   = [
      "s3:*"
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
  
  name  = "IA-AuditTrailServiceRole"
  path  = "/"
  # custom_iam_policy_arns = [
  #   module.iam_policy_glue.arn
  # ]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  target_policy_name = "IA-AuditTrailServiceRoleAccess"
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

#######################
# Glue Database Catalog
#######################
module "glue_database" {
  source = "./../../modules/multi-region/glue/database"

  create = "${var.create_database}"

  name = "${var.db_name}"

  description  = "${var.db_description}"
}

#######################
# Glue Crawler
#######################
module "glue_crawler" {
  source = "./../../modules/multi-region/glue/crawler"

  create = "${var.create_crawler}"

  name = "${var.crawl_name}"
  db   = module.glue_database.name
  role = module.iam_role.this_role_name

  schedule     = "${var.crawl_schedule}"
  table_prefix = "${var.crawl_table_prefix}"
  data_source_paths = [
    for obj in var.obj_name: 
    format ("%s%s%s%s","s3://",module.s3_module.this_s3_bucket_id,"/",obj)  
  ]
}

#######################
# Create Athena Tables and views
#######################
# module "athena_tables" {
#   source = "./../../modules/multi-region/athena"
# #   name = "ia-autittrail"
# #   db_name = "ia-audittrail"
# #   query = <<EOF
# # CREATE EXTERNAL TABLE IF NOT EXISTS audittrail (
# #   recordid STRING,
# #   objecttype STRING,
# #   objectkey STRING,
# #   objectdesc STRING,
# #   userid STRING,
# #   accesstime TIMESTAMP,
# #   accessmode STRING,
# #   ipaddress STRING,
# #   source STRING,
# #   workflowaction STRING
# #   ) Partitioned by (cny int, type string, dt int)
# #   ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
# #   WITH SERDEPROPERTIES ( 'serialization.format' = '1')
# #   LOCATION 's3://ia-audittrailbucket/AuditData/'
# # EOF
# }

resource "null_resource" "athena_table1" {
    provisioner     "local-exec" {

        ## success using file://
        #command = "aws athena start-query-execution --query-string file://query11.sql  --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"

        ## fails when using string
        # command = "aws athena start-query-execution --query-string \"CREATE OR REPLACE VIEW query11 AS SELECT * FROM  meta.getresources_vw\" --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"
        command = "aws athena start-query-execution --query-string file://files/create_audittrail.sql --result-configuration OutputLocation=s3://ia-audittrailbucket/AuditData --query-execution-context Database=ia-audittrail --profile=2auth --region=us-west-2"
    }
}
resource "null_resource" "athena_table2" {
    provisioner     "local-exec" {

        ## success using file://
        #command = "aws athena start-query-execution --query-string file://query11.sql  --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"

        ## fails when using string
        # command = "aws athena start-query-execution --query-string \"CREATE OR REPLACE VIEW query11 AS SELECT * FROM  meta.getresources_vw\" --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"
        command = "aws athena start-query-execution --query-string file://files/create_audittrailfields.sql --result-configuration OutputLocation=s3://ia-audittrailbucket/AuditData --query-execution-context Database=ia-audittrail --profile=2auth --region=us-west-2"
    }
}
resource "null_resource" "athena_view" {
    provisioner     "local-exec" {

        ## success using file://
        #command = "aws athena start-query-execution --query-string file://query11.sql  --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"

        ## fails when using string
        # command = "aws athena start-query-execution --query-string \"CREATE OR REPLACE VIEW query11 AS SELECT * FROM  meta.getresources_vw\" --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"
        command = "aws athena start-query-execution --query-string file://files/create_audittrailview.sql --result-configuration OutputLocation=s3://ia-audittrailbucket/AuditData --query-execution-context Database=ia-audittrail --profile=2auth --region=us-west-2"
    }
}

