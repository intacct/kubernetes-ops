locals {
  local_tags = {
    ops_source_repo_path = "${var.base_path}/${var.aws_region}/${var.environment_name}/helm/kube-prometheus-stack",
  }
  tags = merge(var.environment_tags, local.local_tags, { "ops_env" : var.environment_name })
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
    random = {
      source = "hashicorp/random"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }

  backend "remote" {
    organization = "ia-ds"

    workspaces {
      name = "ds_dev_us-west-2_dev01_helm_kubernetes-external-secrets"
    }
  }
}

variable "base_path" {}
variable "base_env_name" {}
variable "aws_region" {}
variable "environment_name" {}
variable "environment_tags" {}
variable "secrets_prefix" {}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = "ia-ds"
    workspaces = {
      name = "ds_${var.base_env_name}_${var.aws_region}_${var.environment_name}_20_eks"
    }
  }
}

#
# EKS authentication
# # https://registry.terraform.io/providers/hashicorp/helm/latest/docs#exec-plugins
provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.environment_name]
      command     = "aws"
    }
  }
}

#
# Helm - kube-prometheus-stack
#
module "kubernetes-external-secrets" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/kubernetes-external-secrets?ref=v1.0.20"

  eks_cluster_oidc_issuer_url = data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url
  helm_values                 = file("${path.module}/values.yaml")
  environment_name            = var.environment_name
  secrets_prefix              = var.secrets_prefix

  depends_on = [
    data.terraform_remote_state.eks
  ]
}
