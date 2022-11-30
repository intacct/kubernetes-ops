locals {
  base_name                = "external-secrets"
}

data "aws_region" "current" {}

resource "kubectl_manifest" "secret_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1alpha1"
    "kind"       = "SecretStore"
    "metadata" = {
      "name"      = var.secret_store_name
      "namespace" = var.namespace
      "labels"    = {
        "managed/by": "terraform"
      }
    }
    "spec" = {
      "provider" = {
        "aws": {
          "service": "SecretsManager"
          "region": data.aws_region.current.name
          "auth": {
            "jwt": {
              "serviceAccountRef": {
                "name": "${local.base_name}-${var.environment_name}"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubectl_manifest" "external_secrets_cluster_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1alpha1"
    "kind"       = "ClusterSecretStore"
    "metadata" = {
      "name"      = var.secret_store_name
      "labels"    = {
        "managed/by": "terraform"
      }
    }
    "spec" = {
      "provider" = {
        "aws": {
          "service": "SecretsManager"
          "region": data.aws_region.current.name
          "auth": {
            "jwt": {
              "serviceAccountRef": {
                "name": "${local.base_name}-${var.environment_name}"
                "namespace": var.namespace
              }
            }
          }
        }
      }
    }
  }
}
