###############################
# Region
###############################
aws_region = "eu-central-1"

###############################
# Common tags
###############################
environment_tags = {
  ops_managed_by  = "terraform",
  ops_source_repo = "do-infrastructure",
  ops_owners      = "devops",
}

###############################
# VPC
###############################
vpc_cidr        = "10.54.0.0/16"
private_subnets = ["10.52.0.0/18", "10.52.64.0/18", "10.52.128.0/18"]
public_subnets  = ["10.52.224.0/19"]
zones           = ["a", "b", "c"]
