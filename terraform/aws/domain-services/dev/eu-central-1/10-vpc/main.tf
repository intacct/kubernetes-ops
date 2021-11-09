locals {
  local_tags = {
    ops_source_repo_path = "${var.base_path}/${var.aws_region}/${var.environment_name}/10-vpc",
  }
  tags = merge(var.environment_tags, local.local_tags)
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
      name = "ds_eu-central-1_10_vpc_dev"
    }
  }
}

variable "base_path" {}
variable "aws_region" {}
variable "environment_name" {}
variable "environment_tags" {}

provider "aws" {
  region = var.aws_region
}

#
# VPC
#
module "vpc" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/vpc?ref=v1.0.24"

  aws_region       = var.aws_region
  azs              = ["${var.aws_region}a", "${var.aws_region}c", "${var.aws_region}c"]
  vpc_cidr         = "10.54.0.0/16"
  private_subnets  = ["10.54.1.0/24", "10.54.2.0/24", "10.54.3.0/24"]
  public_subnets   = ["10.54.101.0/24", "10.54.102.0/24", "10.54.103.0/24"]
  environment_name = var.environment_name
  cluster_name     = var.environment_name
  tags             = local.tags
}
