locals {
  aws_region       = "eu-central-1"
  environment_name = "dev"
  domain_name      = "dev2.k8s.managedkube.com"
  tags = {
    ops_env              = "dev"
    ops_managed_by       = "terraform",
    ops_source_repo      = "do-infrastructure",
    ops_source_repo_path = "terraform/aws/domain-services/${local.environment_name}/eu-central-1/5-route53-hostedzone",
    ops_owners           = "devops",
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
    organization = "intacct"

    workspaces {
      name = "terraform_aws_domain-services_dev_eu-central-1_5-route53-hostedzone"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#
# Route53 Hosted Zone
#
module "route53-hostedzone" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/route53/hosted-zone?ref=v1.0.19"

  domain_name = local.domain_name
  tags        = local.tags
}
