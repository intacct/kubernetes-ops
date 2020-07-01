#################
# Common vars
# These are common to both USW and EUC regions
#################
variable "auth_profile" { default = "2auth" }

variable "acl" { default = "private" }

variable "create_bucket" {
  description = "Set it false if bucket creation should be disabled"
  type        = bool
  default     = true
}

variable "bucket" { default = "ia-audittrailbucket" }

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {
      "Name" = "ia-audittrailbucket"
  }
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
  type        = list
  default     = ["audittrail/","audittrailfields/"]
}

variable "create_s3_objects" {
  description = "Set it to true if s3 objects/folders need to be created"
  type        = bool
  default     = true
}

##################
# IAM User
##################
variable "user_name" { default = ["IA-AuditTrailUser"] } 
variable "pgp_key" { default = "keybase:kaysree" }
variable "password_len" { default = 10 }
variable "require_password_reset" { default = false }

##################
# IAM Group
##################
variable "group_name" { default = "IA-AuditTrailUserGroup" }

##################
# IAM Policy
##################
variable "policy_name" { default = "IA-AuditTrailUserAccess" }
variable "policy_path" { default = "/" }

##################
# Service Role
##################
variable "role_name" { default = "IA-AuditTrailServiceRole" }
variable "role_path" { default = "/" }
variable "role_policy_name" { default = "IA-AuditTrailServiceRoleAccess" }



##################
# Glue
##################
# # ---- aws_glue_catalog_database
variable "create_database" { default = true }
variable "db_name" { default = "ia-audittrail" }
variable "db_description" { default = "IntAcct Audit Trail Database" }
variable "db_catalog_id" { default = "" }
variable "db_location_uri" { default = "" }
variable "db_params" {
  type    = "map"
  default = {}
}

# # --- aws_glue_catalog_table
variable "create_table" { default = true }
variable "table1_name" { default = "audittrail" }

# audittrail table description
variable "table1_description" { default = "audit trail table" }

# audittrail table partiion keys
variable "table1_partition_keys" {
    default = [
      ["cny", "string"],
      ["type", "string"],
      ["dt", "string"]
    ]
}

# audittrail table type
variable "table1_type" { default = "EXTERNAL_TABLE" }

# audittrail table parameters
variable "table1_parameters" {
    default = [
        {
            EXTERNAL = "TRUE"
        }
    ]
}

# audittrail table columns
variable "table1_columns" {
    default = [
      ["recordid", "string"],
      ["objecttype", "string"],
      ["objectkey", "string"],
      ["objectdesc", "string"],
      ["userid", "string"],
      ["accesstime", "bigint"],
      ["accessmode", "string"],
      ["ipaddress", "string"],
      ["source", "string"],
      ["workflowaction", "string"]
    ]
}

variable "table2_name" { default = "audittrailfields" }
variable "table2_description" { default = "audit trail fields table" }
variable "table2_partition_keys" {
    default = [
      ["cny", "string"],
      ["type", "string"],
      ["dt", "string"]
    ]
}
variable "table2_type" { default = "EXTERNAL_TABLE" }
variable "table2_parameters" {
    default = [
        {
            EXTERNAL = "TRUE"
        }
    ]
}

variable "table2_columns" {
    default = [
      ["recordid", "string"],
      ["fieldname", "string"],
      ["fieldtype", "string"],
      ["oldval", "string"],
      ["newval", "string"],
      ["oldstrval", "string"],
      ["newstrval", "string"],
      ["oldintval", "string"],
      ["newintval", "string"],
      ["oldnumval", "string"],
      ["newnumval", "string"],
      ["olddateval", "string"],
      ["newdateval", "string"]
    ]
}

variable "table3_name" { default = "audittrailview" }
variable "table3_description" { default = "audit trail view" }
variable "table3_type" { default = "VIRTUAL_VIEW" }

variable "table3_parameters" {
  default = [
      {        
        presto_view = "true"
        comment     = "Presto View"    
      }
  ]
}

variable "table3_columns" {
  default = [
    ["cny", "string"],
    ["type", "string"],
    ["dt", "string"],
    ["recordid", "string"],
    ["objecttype", "string"],
    ["objectkey", "string"],
    ["objectdesc", "string"],
    ["userid", "string"],
    ["accesstime", "bigint"],
    ["accessmode", "string"],
    ["ipaddress", "string"],
    ["source", "string"],
    ["workflowaction", "string"],
    ["fieldname", "string"],
    ["fieldtype", "string"],
    ["oldval", "string"],
    ["newval", "string"],
    ["oldstrval", "string"],
    ["newstrval", "string"],
    ["oldintval", "string"],
    ["newintval", "string"],
    ["oldnumval", "string"],
    ["newnumval", "string"],
    ["olddateval", "string"],
    ["newdateval", "string"]
  ]
}

# # ---- aws_glue_crawler
variable "create_crawler" { default = true }
variable "crawl_name" { default = "IA-AuditDataCrawler" }
variable "crawl_role" { default = "" }
variable "crawl_database" { default = "" }

# Run at 1:15a every day
variable "crawl_schedule" {
  description = "cron(Minutes Hours Day-of-month Month Day-of-week Year)"
  default = "cron(15 1 * * ? *)"
}

variable "crawl_table_prefix" { default = "" }


#################
# USW specific vars
#################
variable "region" { default = "us-west-2" }
variable "keyname" { default = "sridhar.krishnamurthy" }

