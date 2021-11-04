
#################
# Common vars
# These are common to both USW and EUC regions
#################
variable "auth_profile" {}
variable "region" {}
# variable "keyname" {}
# variable "pgp_key" {}
# variable "password_len" {}
# variable "require_password_reset" {}
# variable "acl" { default = "private" }
variable "name_prefix" {}

##################
# VPC
##################
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "create_vpc" {}

##################
# Subnets
##################
variable "private_subnets" {}
# variable "private_subnet_names" {}
variable "public_subnets" {}
variable "intra_subnets" {}
# variable "public_subnet_names" {}
variable "route_inst_cidr_block" {}

##################
# Elastic Container Repository
##################
variable "create_repository" {}
variable "repository_names" { type = list(string) }
variable "attach_lifecycle_policy" {}

##################
# IAM User
##################
variable "console_users" {} 
variable "service_users" {} 
variable "ecr_users" {} 
variable "password_len" {}
variable "pgp_key" {}


##################
# IAM Group
##################
variable "ecr_group_name" {}

##################
# IAM Policy
##################
variable "policy_name" {}
variable "policy_path" {}

##################
# EC2
##################

variable "use_name_prefix" { type = bool }
variable "ec2_name_prefix" { type = string }
variable "instance_name" { type = string }
# variable "vpc_id" { type = string }
# variable "subnet_suffix" { type = string }
variable "ami" { type = string }
variable "use_num_suffix" { type = bool }
variable "instance_type" { type = string }
# variable "subnet_id" { type = string }
variable "private_ips" { type = list(string) }
variable "hostnames" { type = list(string) }
# variable "exec_script" { type = string }
variable "key_name" { type = string }
variable "key_file" { type = string }
variable "sg_name" { type = string }
variable "sg_description" { type = string }
variable "ebs_devices" { type = list }
variable "default_inbound" {}
variable "custom_inbound" {}
variable "default_outbound" {}
variable "custom_outbound" {}


##################
# VPC Peering
##################
variable "owner_vpc_id" {}
variable "peer_vpc_id" {}
variable "peer_acc_id" {}
variable "eng_peer_vpc_id" {}
variable "eng_peer_acc_id" {}

##################
# AWS Routes
##################

##################
# EKS Cluster
##################
variable "eks_cluster_name" {}
variable "eks_environment_name" {}

variable "tags" {
  type = map(any)
  default = {
    ops_env              = "dev"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "do-infrastructure/terraform/aws/usw/domain-services",
    ops_owners           = "devops",
  }
}

##################
# Hosted zone
##################
variable "domain_name" {}

##################
# Cert manager
##################
variable "lets_encrypt_email" {}
