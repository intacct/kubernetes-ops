resource "kubernetes_manifest" "external_secret" {
  for_each = var.external_secret

  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ExternalSecret"
    "metadata" = {
      "name" = each.value.name
      "namespace" = each.value.namespace
    }
    "spec" = {
      "refreshInterval" = "1h"
      "secretStoreRef" = {
        "name" = "secretstore-main"
        "kind" = "ClusterSecretStore"
      }
      "target" = {
        "name" = each.value.name
        "template" = {
          "metadata" = {
            "annotations" = {
              "reflector.v1.k8s.emberstack.com/reflection-allowed" = "true"
              "reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces" = each.value.allowed_namespaces
              "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
            }
          }
        }
      }
      "data" = [
        for data_item in each.value.data : {
          "secretKey" = data_item.secret_key
          "remoteRef" = {
            "key" = data_item.remote_key
            "property" = data_item.remote_property
          }
        }
      ]
    }
  }
}
