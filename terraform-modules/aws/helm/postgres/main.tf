resource "helm_release" "helm_chart" {
  chart            = "postgresql-ha"
  namespace        = var.namespace
  create_namespace = "true"
  name             = "${var.release_name}-${var.eks_cluster_id}"
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://charts.bitnami.com/bitnami"

  values = [
    file("${path.module}/values.yaml"),
    var.helm_values,
  ]

}