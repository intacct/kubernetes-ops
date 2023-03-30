resource "helm_release" "helm_chart" {
  chart            = "reflector"
  namespace        = var.namespace
  create_namespace = "true"
  name             = "${var.chart_name}-${var.eks_cluster_id}"
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://emberstack.github.io/helm-charts"

  values = [
    file("${path.module}/values.yaml"),
    var.helm_values,
  ]

}