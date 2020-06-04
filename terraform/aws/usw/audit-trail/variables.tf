#################
# Common vars
# These are common to both USW and EUC regions
#################
variable "auth_profile" {
    default = "2auth"
}

variable "acl" {
    default = "private"
}

variable "create_bucket" {
  description = "Set it false if bucket creation should be disabled"
  type        = bool
  default     = true
}

variable "bucket" {
    default = "ia-audittrailbucket"
}

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
  default     = ["AuditData/","AuditFieldsData/"]
}

variable "create_s3_objects" {
  description = "Set it to true if s3 objects/folders need to be created"
  type        = bool
  default     = true
}

##################
# Glue
##################
# # ---- aws_glue_catalog_database
variable "create_database" {
  default = true
}

variable "db_name" {
  default = "ia-audittrail"
}

variable "db_description" {
  default = "IntAcct Audit Trail Database"
}

variable "db_catalog_id" {
  default = ""
}

variable "db_location_uri" {
  default = ""
}

variable "db_params" {
  type    = "map"
  default = {}
}

# # ---- aws_glue_crawler
variable "create_crawler" {
  default = true
}

variable "crawl_name" {
  default = "IA-AuditDataCrawler"
}

variable "crawl_role" {
  default = ""
}

variable "crawl_database" {
  default = ""
}

# Run at 1:15a every day
variable "crawl_schedule" {
  description = "cron(Minutes Hours Day-of-month Month Day-of-week Year)"
  default = "cron(15 1 * * ? *)"
}

variable "crawl_table_prefix" {
  default = ""
}


#################
# USW specific vars
#################
variable "region" {
  default = "us-west-2"
}

variable "keyname" {
  default = "sridhar.krishnamurthy"
}

