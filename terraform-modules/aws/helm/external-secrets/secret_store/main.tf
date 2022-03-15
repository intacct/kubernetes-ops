locals {
  base_name = "external-secrets"
}

data "aws_region" "current" {}

resource "kubectl_manifest" "secret_store" {
  yaml_body = <<-EOF
    apiVersion: external-secrets.io/v1alpha1
    kind: SecretStore
    metadata:
      name: cluster_store
      namespace: kubernetes-external-secrets
      labels: "managed/by: terraform"
    spec:
      provider:
        aws:
          service: SecretsManager
          region: us-west-2
          auth: jwt
            serviceAccountRef:
               name: kubernetes-external-secrets-dc06
               namespace: kubernetes-external-secrets

    EOF
}



resource "kubectl_manifest" "external_secrets_cluster_store" {
  yaml_body = <<-EOF
    apiVersion: external-secrets.io/v1alpha1
    kind: ClusterSecretStore
    metadata:
      name: external_secrets_cluster_store
      labels: "managed/by: terraform"
      namespace: kubernetes-external-secrets
    spec:
      provider:
        aws:
          service: SecretsManager
          region: us-west-2
          auth: jwt
            serviceAccountRef:
               name: kubernetes-external-secrets-dc06
               namespace: kubernetes-external-secrets

    EOF
}
