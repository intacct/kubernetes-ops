variable "region" { type = string }
variable "profile" { type = string }
variable "use_name_prefix" { type = bool }
variable "name_prefix" { type = string }
variable "instance_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_suffix" { type = string }
variable "ami" { type = string }
variable "use_num_suffix" { type = bool }
variable "instance_type" { type = string }
variable "subnet_id" { type = string }
variable "private_ips" { type = list(string) }
variable "hostnames" { type = list(string) }
variable "exec_script" { type = string }
variable "key_name" { type = string }
variable "key_file" { type = string }
variable "sg_name" { type = string }
variable "sg_description" { type = string }
variable "ebs_devices" { type = list }
variable "default_inbound" {}
variable "custom_inbound" {}
variable "default_outbound" {}
variable "custom_outbound" {}
variable "create_sg" {}
