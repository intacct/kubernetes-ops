resource "null_resource" "vpa_deployment" {
  provisioner "local-exec" {
    command = <<EOF
      git clone https://github.com/kubernetes/autoscaler.git
      cd autoscaler/vertical-pod-autoscaler/
      ./hack/vpa-up.sh
    EOF
  }
}

resource "null_resource" "vpa_undeployment" {
  provisioner "local-exec" {
    command = <<EOF
      cd autoscaler/vertical-pod-autoscaler/
      ./hack/vpa-down.sh
    EOF
  }

  depends_on = [null_resource.vpa_deployment]
}