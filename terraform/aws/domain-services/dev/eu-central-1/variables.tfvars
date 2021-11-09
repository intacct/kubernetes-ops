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
vpc_cidr         = "10.54.0.0/16"
private_subnets  = ["10.54.1.0/24", "10.54.2.0/24", "10.54.3.0/24"]
public_subnets   = ["10.54.101.0/24", "10.54.102.0/24", "10.54.103.0/24"]
