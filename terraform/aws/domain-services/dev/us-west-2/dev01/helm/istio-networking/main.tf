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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "remote" {
    organization = "ia-ds"

    workspaces {
      name = "ds_dev_us-west-2_dev01_helm_istio-networking"
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

data "aws_eks_cluster_auth" "main" {
  name = var.environment_name
}

provider "kubectl" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
}

# file templating
data "template_file" "gateway_yaml" {
  template = file("${path.module}/gateway.tpl.yaml")

  # vars = {
  #   fullnameOverride  = local.fullnameOverride
  # }
}

resource "kubectl_manifest" "gateway" {
  yaml_body = data.template_file.gateway_yaml.rendered
}

# file templating
data "template_file" "virtualservice_yaml" {
  template = file("${path.module}/virtualservice.tpl.yaml")

  # vars = {
  #   fullnameOverride  = local.fullnameOverride
  # }
}

resource "kubectl_manifest" "virtualservice" {
  yaml_body = data.template_file.virtualservice_yaml.rendered
}
