# ----------------------------------------------------------------------------------------------------------------------
# Common vars
# These are common to both USW and EUC regions
# ----------------------------------------------------------------------------------------------------------------------
variable "auth_profile" { default = "2auth" }

variable "acl" { default = "private" }

variable "create_bucket" {
  description = "Set it false if bucket creation should be disabled"
  type        = bool
  default     = true
}

variable "bucket" { 
  type = list
  default = ["ia-audittrailbucket"]
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = list
  default     = [{
      "Name" = "ia-audittrailbucket"
  }]
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {
      "enabled" = true
  }
}

variable "obj_name" {
  description = "Name of the object/folder to be created inside bucket"
}

variable "glue_obj_name" {
  description = "Name of the object/folder to be created inside bucket"
  type        = list
  default     = ["glue-script/", "glue-temp/"]
}

variable "create_s3_objects" {
  description = "Set it to true if s3 objects/folders need to be created"
  type        = bool
  default     = true
}

variable "environment_tag" {}

# ----------------------------------------------------------------------------------------------------------------------
# IAM User
# ----------------------------------------------------------------------------------------------------------------------
variable "user_name" { default = ["IA-AuditTrailUser"] } 
variable "pgp_key" { default = "keybase:kaysree" }
variable "password_len" { default = 10 }
variable "require_password_reset" { default = false }

# ----------------------------------------------------------------------------------------------------------------------
# IAM Group
# ----------------------------------------------------------------------------------------------------------------------
variable "group_name" { default = "IA-AuditTrailUserGroup" }

# ----------------------------------------------------------------------------------------------------------------------
# IAM Policy
# ----------------------------------------------------------------------------------------------------------------------
variable "policy_name" { default = "IA-AuditTrailUserAccess" }
variable "policy_path" { default = "/" }

# ----------------------------------------------------------------------------------------------------------------------
# Service Role
# ----------------------------------------------------------------------------------------------------------------------
variable "role_name" { default = "IA-AuditTrailServiceRole" }
variable "role_path" { default = "/" }
variable "role_policy_name" { default = "IA-AuditTrailServiceRoleAccess" }



# ----------------------------------------------------------------------------------------------------------------------
# Glue
# ----------------------------------------------------------------------------------------------------------------------
# # ---- aws_glue_catalog_database
variable "create_database" { default = true }
variable "db_name" { default = "ia-audittrail" }
variable "db_description" { default = "IntAcct Audit Trail Database" }
variable "db_catalog_id" { default = "" }
variable "db_location_uri" { default = "" }
variable "db_params" {
  type    = map
  default = {}
}

# ----------------------------------------------------------------------------------------------------------------------
# Glue Job
# ----------------------------------------------------------------------------------------------------------------------
variable "create_job" { default = false }
variable "job_name" { default = "ia-autittrailjob" }
variable "language" { default = "python" }


# ----------------------------------------------------------------------------------------------------------------------
# Glue table parameters
# ----------------------------------------------------------------------------------------------------------------------
variable "create_table" {}
variable "table_names" {}
variable "table_descriptions" {}
variable "table_input_formats" {}
variable "table_output_formats" {}
variable "table_serialization_libs" {}
variable "table_types" {}
variable "table_parameters" {}
variable "table_storage_parameters" {}
variable "table_serde_parameters" {}
variable "table_columns" {}
variable "table_partition_keys" {}

# variable "table1_name" {}
# variable "table1_description" {}
# variable "table1_partition_keys" {}
# variable "table1_type" {}
# variable "table1_parameters" {}
# variable "table1_columns" {}

# variable "table2_name" {}
# variable "table2_description" {}
# variable "table2_partition_keys" {}
# variable "table2_type" {}
# variable "table2_parameters" {}
# variable "table2_columns" {}

variable "create_view" {}
variable "view1_name" {}
variable "view1_description" {}
variable "view1_type" {}
variable "view1_parameters" {}
variable "view1_columns" {}

# ----------------------------------------------------------------------------------------------------------------------
# Crawler
# ----------------------------------------------------------------------------------------------------------------------
variable "crawler1_create" {}
variable "crawler1_name" {}
variable "crawler1_schema_delete_behavior" {}
variable "crawler1_schedule" {}
variable "crawler1_table_prefix" { default = "" }
variable "crawler1_configuration" {}

variable "crawler2_create" {}
variable "crawler2_name" {}
variable "crawler2_schema_delete_behavior" {}
variable "crawler2_schema_update_behavior" {}
variable "crawler2_schedule" {}
variable "crawler2_table_prefix" { default = "" }
variable "crawler2_configuration" {}

variable "crawler3_create" {}
variable "crawler3_name" {}
variable "crawler3_schema_delete_behavior" {}
variable "crawler3_schema_update_behavior" {}
variable "crawler3_schedule" {}
variable "crawler3_table_prefix" { default = "" }
variable "crawler3_configuration" {}

variable "crawler4_create" {}
variable "crawler4_name" {}
variable "crawler4_schema_delete_behavior" {}
variable "crawler4_schema_update_behavior" {}
variable "crawler4_schedule" {}
variable "crawler4_table_prefix" { default = "" }
variable "crawler4_configuration" {}




# ----------------------------------------------------------------------------------------------------------------------
# Lambda
# ----------------------------------------------------------------------------------------------------------------------
variable "create_lambda" {}
variable "lambda_funct_name" {}
variable "lambda_funct_description" {}
variable "lambda_handler" {}
variable "lambda_upload_role_name" {}
variable "lambda_role_path" {}
variable "lambda_role_policy_name" {}
variable "lambda_runtime" {}
variable "lambda_timeout" {}
variable "lambda_memory_size" {}

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Layer
# ----------------------------------------------------------------------------------------------------------------------
variable "create_layer" {}
variable "layer_name" {}
variable "layer_description" {}
variable "layer_runtime" {}
variable "layer_license" {}


# ----------------------------------------------------------------------------------------------------------------------
# USW specific vars
# ----------------------------------------------------------------------------------------------------------------------
variable "region" { default = "us-west-2" }
variable "keyname" { default = "sridhar.krishnamurthy" }

