locals {
  local_tags = {
    ops_source_repo_path = "${var.base_path}/${var.aws_region}/${var.environment_name}/helm/grafana-loki",
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
      name = "ds_dev_us-west-2_dev01_helm_grafana-loki"
    }
  }
}

variable "base_path" {}
variable "base_env_name" {}
variable "aws_region" {}
variable "environment_name" {}
variable "environment_tags" {}

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
      args        = ["eks", "get-token", "--cluster-name", "${var.environment_name}"]
      command     = "aws"
    }
  }
}

#
# Helm - grafana-loki-stack
#
# Doc: https://github.com/grafana/helm-charts/tree/main/charts/loki-stack
module "loki" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.9"

  repository          = "https://grafana.github.io/helm-charts"
  official_chart_name = "loki-stack"
  user_chart_name     = "loki-stack"
  helm_version        = "2.5.0"
  namespace           = "monitoring"
  helm_values         = file("${path.module}/values.yaml")

  depends_on = [
    data.terraform_remote_state.eks
  ]
}
