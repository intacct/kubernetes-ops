variable "region" { type = string }
variable "profile" { type = string }
variable "vpc_id" { type = string }
variable "name" { type = string }
variable "subnet_id" { type = list(string) }
variable "subnet_suffix" { type = string }
variable "default_inbound" { type = list }
variable "default_outbound" { type = list }
variable "public_inbound" {}
variable "public_outbound" {}