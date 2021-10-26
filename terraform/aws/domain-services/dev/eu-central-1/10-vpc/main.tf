locals {
  aws_region       = "eu-central-1"
  environment_name = "dev"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "do-infrastructure",
    ops_source_repo_path = "terraform/aws/domain-services/${local.environment_name}/eu-central-1/10-vpc",
    ops_owners           = "devops",
    temp                 = "temp tag",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" {
    organization = "ia-ds"

    workspaces {
      name = "terraform_aws_domain-services_dev_eu-central-1_10-vpc"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#
# VPC
#
module "vpc" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/vpc?ref=v1.0.24"

  aws_region       = local.aws_region
  azs              = ["eu-central-1a", "eu-central-1c", "eu-central-1d"]
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  environment_name = local.environment_name
  cluster_name     = local.environment_name
  tags             = local.tags
}
