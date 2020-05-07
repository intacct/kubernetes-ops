variable "create" {
  default = true
}


# Name of the crawler
variable "name" {}

# Glue database where results are written
variable "db" {}

# Description of the crawler
variable "description" {
  default = ""
}

# The IAM role friendly name (including path without leading slash), or ARN of an IAM role, 
# used by the crawler to access other resources
variable "role" {}

# A cron expression used to specify the schedule. For more information, 
# see Time-Based Schedules for Jobs and Crawlers. For example, to run something 
# every day at 12:15 UTC, you would specify: cron(15 12 * * ? *). 
variable "schedule" {
  default = ""
}

variable "table_prefix" {}

# The path to the Amazon S3 target
variable "data_source_paths" {
  type = any
}

variable "s3_exclusions" {
  type    = "list"
  default = []
}