locals {
  local_tags = {
    ops_source_repo_path = "${var.base_path}/${var.aws_region}/${var.environment_name}/20-eks",
  }
  tags = merge(var.environment_tags, local.local_tags, { "ops_env" : var.environment_name })
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
      name = "ds_dev_eu-central-1_dev01_20_eks"
    }
  }
}

variable "base_path" {}
variable "base_env_name" {}
variable "aws_region" {}
variable "environment_name" {}
variable "environment_tags" {}
variable "vpc_cidr" {}
variable "private_subnets" {}
variable "public_subnets" {}
variable "zones" {}
variable "cluster_version" {}
variable "cluster_endpoint_public_access_cidrs" {}
variable "cluster_endpoint_private_access_cidrs" {}
variable "map_roles" {}
variable "map_users" {}
variable "node_groups" {}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "ia-ds"
    workspaces = {
      name = "ds_${var.base_env_name}_${var.aws_region}_${var.environment_name}_10_vpc"
    }
  }
}

#
# EKS
#
module "eks" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/eks?ref=v1.0.25"

  aws_region = var.aws_region
  tags       = local.tags

  cluster_name = var.environment_name

  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  k8s_subnets    = data.terraform_remote_state.vpc.outputs.k8s_subnets
  public_subnets = data.terraform_remote_state.vpc.outputs.public_subnets

  cluster_version = var.cluster_version

  # public cluster - kubernetes API is publicly accessible
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  # private cluster - kubernetes API is internal the the VPC
  cluster_endpoint_private_access                = true
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs = var.cluster_endpoint_private_access_cidrs

  map_roles = var.map_roles
  map_users = var.map_users

  node_groups = var.node_groups
}
