locals {
  local_tags = {
    ops_source_repo_path = "${var.base_path}/${var.environment_name}/${var.aws_region}/10-vpc",
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
      name = "ds_dev_eu-central-1_10_vpc"
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
  vpc_cidr         = var.vpc_cidr
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  environment_name = var.environment_name
  cluster_name     = var.environment_name
  tags             = local.tags
}
