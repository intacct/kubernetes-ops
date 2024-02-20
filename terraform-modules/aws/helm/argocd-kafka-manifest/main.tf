resource "kubernetes_manifest" "application_set" {
  for_each = var.kafka_clusters
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "ApplicationSet"
    "metadata" = {
      "name"      = "${each.value.k8s_cluster}-${each.value.env}-kafka"
      "namespace" = "argocd"
    }
    "spec" = {
      "generators" = [
        {
          "list" = {
            "elements" = [
              {
                "cluster" = each.value.k8s_cluster
                "app"     = "kafka"
              }
            ]
          }
        }
      ]
      "template" = {
        "metadata" = {
          "name" = "${each.value.k8s_cluster}-${each.value.env}-kafka"
        }
        "spec" = {
          "destination" = {
            "namespace" = "${each.value.env}-ia-kafka"
            "name"      = each.value.k8s_cluster
          }
          "project" = "appbundle-project-${each.value.jfrog}"
          "sources" = [
            {
              "path"           = "charts/kafka-chart"
              "repoURL"        = "git@github.com:intacct/ia-helm-charts.git"
              "targetRevision" = each.value.helm_branch
              "helm" = {
                "parameters" = [
                  {
                    "name"  = "kafka.environment"
                    "value" = each.value.env
                  },
                  {
                    "name"  = "kafka.namespace"
                    "value" = "${each.value.env}-ia-kafka"
                  },
                  {
                    "name"  = "kafka.connect.image.repository"
                    "value" = "intacct.jfrog.io/ia-ds-docker-${each.value.jfrog}/ia-kafka-connect"
                  }
                ]
                "valueFiles" = [
                  "$do-kafka/kafka-helm/helm_values.yaml",
                  "$do-kafka/kafka-helm/values_${each.value.jfrog}.yaml"
                ]
              }
            },
            {
              "repoURL"        = "git@github.com:Intacct/do-kafka-infra"
              "targetRevision" = "main"
              "ref"            = "do-kafka"
            }
          ]
          "syncPolicy" = {
            "automated" = {
              "allowEmpty" = false
              "prune"      = true
              "selfHeal"   = true
            }
            "managedNamespaceMetadata" = {
              "labels" = {
                "istio-injection" = "enabled"
              }
            }
            "syncOptions" = ["CreateNamespace=true"]
          }
        }
      }
    }
  }
}