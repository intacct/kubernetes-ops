resource "helm_release" "helm_chart" {
  chart            = "awx-operator"
  namespace        = var.namespace
  create_namespace = "true"
  name             = "${var.chart_name}-${var.eks_cluster_id}"
  #name             = awx-operator
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://ansible.github.io/awx-operator/"

  values = [
    file("${path.module}/values.yaml"),
    var.helm_values,
  ]

}