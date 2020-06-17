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
    actions = [
      "athena:BatchGetNamedQuery",
      "athena:BatchGetQueryExecution", 
      "athena:CancelQueryExecution",
      "athena:CreateNamedQuery",
      "athena:DeleteNamedQuery",
      "athena:GetCatalogs",
      "athena:GetExecutionEngine",
      "athena:GetExecutionEngines",
      "athena:GetNamedQuery",
      "athena:GetNamespace",
      "athena:GetNamespaces",
      "athena:GetQueryExecution",
      "athena:GetQueryExecutions",
      "athena:GetQueryResults",
      "athena:GetQueryResultsStream",
      "athena:GetTable",
      "athena:GetTables",
      "athena:GetWorkGroup",
      "athena:ListNamedQueries",
      "athena:ListQueryExecutions",
      "athena:ListTagsForResource", 
      "athena:ListWorkGroups",
      "athena:StartQueryExecution",
      "athena:StopQueryExecution",
      "athena:TagResource",
      "athena:UntagResource"
    ]
    effect = "Allow"
    resources = [
      # "arn:aws:athena:*"
      "*"
    ]
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
      module.s3_module.this_s3_bucket_arn, format("%s%s", module.s3_module.this_s3_bucket_arn,"/*")
    ]
  }
}

module "iam_user" {
  source                  = "../../modules/multi-region/iam-user"
  name                    = var.user_name
  force_destroy           = true
  pgp_key                 = var.pgp_key
  password_length         = var.password_len
  password_reset_required = var.require_password_reset
}

module "iam_group" {
  source                            = "../../modules/multi-region/iam-group"
  # version = "~> 2.0"
  name                              = var.group_name
  group_users                       = [
    module.iam_user.this_iam_user_name
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

#######################
# Glue Database Catalog
#######################
module "glue_database" {
  source       = "./../../modules/multi-region/glue/database"
  create       = var.create_database
  name         = var.db_name
  description  = var.db_description
}

module "glue_table1" {
  source            = "../../modules/multi-region/glue/table"
  create_table      = true
  table_name        = var.table1_name
  db_name           = var.db_name
  table_description = var.table1_description
  partition_keys    = var.table1_partition_keys
  table_type        = var.table1_type
  parameters        = var.table1_parameters
  location_url      = format ("%s%s%s%s","s3://",module.s3_module.this_s3_bucket_id,"/",var.obj_name[0])
  columns           = var.table1_columns
}

module "glue_table2" {
  source            = "../../modules/multi-region/glue/table"
  create_table      = true
  table_name        = var.table2_name
  db_name           = var.db_name
  table_description = var.table2_description
  partition_keys    = var.table2_partition_keys
  table_type        = var.table2_type
  parameters        = var.table2_parameters
  location_url      = format ("%s%s%s%s","s3://",module.s3_module.this_s3_bucket_id,"/",var.obj_name[1])
  columns           = var.table2_columns
}

module "glue_table3" {
  source            = "../../modules/multi-region/glue/view"
  create_table      = true
  table_name        = var.table3_name
  db_name           = var.db_name
  table_description = var.table3_description
  table_type        = var.table3_type
  parameters        = ""
  columns           = var.table3_columns
  location_url      = ""
}


#######################
# Glue Crawler
#######################
module "glue_crawler" {
  source       = "./../../modules/multi-region/glue/crawler"
  create       = var.create_crawler
  name         = var.crawl_name
  db           = module.glue_database.name
  role         = module.iam_role.this_role_name
  schedule     = var.crawl_schedule
  table_prefix = var.crawl_table_prefix
  data_source_paths = [
    for obj in var.obj_name: 
    format ("%s%s%s%s","s3://",module.s3_module.this_s3_bucket_id,"/",obj)  
  ]
}

# resource "null_resource" "audittrail" {
#     provisioner     "local-exec" {

#         ## success using file://
#         #command = "aws athena start-query-execution --query-string file://query11.sql  --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"

#         ## fails when using string
#         # command = "aws athena start-query-execution --query-string \"CREATE OR REPLACE VIEW query11 AS SELECT * FROM  meta.getresources_vw\" --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"
#         command = "aws athena start-query-execution --query-string file://files/create_audittrail.sql --result-configuration OutputLocation=s3://ia-audittrailbucket/AuditData --query-execution-context Database=ia-audittrail --profile=2auth --region=us-west-2"
#     }
# }
# resource "null_resource" "audittrailfields" {
#     provisioner     "local-exec" {

#         ## success using file://
#         #command = "aws athena start-query-execution --query-string file://query11.sql  --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"

#         ## fails when using string
#         # command = "aws athena start-query-execution --query-string \"CREATE OR REPLACE VIEW query11 AS SELECT * FROM  meta.getresources_vw\" --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"
#         command = "aws athena start-query-execution --query-string file://files/create_audittrailfields.sql --result-configuration OutputLocation=s3://ia-audittrailbucket/AuditData --query-execution-context Database=ia-audittrail --profile=2auth --region=us-west-2"
#     }
# }
# resource "null_resource" "athena_view" {
#     provisioner     "local-exec" {

#         ## success using file://
#         #command = "aws athena start-query-execution --query-string file://query11.sql  --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"

#         ## fails when using string
#         # command = "aws athena start-query-execution --query-string \"CREATE OR REPLACE VIEW query11 AS SELECT * FROM  meta.getresources_vw\" --output json --query-execution-context Database=${aws_athena_database.metadb.id} --result-configuration OutputLocation=s3://xxxxxxx2"
#         command = "aws athena start-query-execution --query-string file://files/create_audittrailview.sql --result-configuration OutputLocation=s3://ia-audittrailbucket/AuditData --query-execution-context Database=ia-audittrail --profile=2auth --region=us-west-2"
#     }
# }

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
