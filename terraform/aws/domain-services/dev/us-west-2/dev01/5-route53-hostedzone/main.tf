locals {
  local_tags = {
    ops_source_repo_path = "${var.base_path}/${var.aws_region}/${var.environment_name}/5-route53-hostedzone",
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
      name = "ds_dev_us-west-2_dev01_5-route53-hostedzone"
    }
  }
}

variable "base_path" {}
variable "base_env_name" {}
variable "aws_region" {}
variable "environment_name" {}
variable "environment_tags" {}
variable "domain_name" {}

provider "aws" {
  region = var.aws_region
}

#
# Route53 Hosted Zone
#
module "route53-hostedzone" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/route53/hosted-zone?ref=v1.0.19"

  domain_name = var.domain_name
  tags        = local.tags
}
 