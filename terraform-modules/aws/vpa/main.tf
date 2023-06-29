resource "null_resource" "vpa_deployment" {
  provisioner "local-exec" {
    command     = "./hack/vpa-up.sh"
    working_dir = "autoscaler/vertical-pod-autoscaler"
    when        = create
  }

  provisioner "local-exec" {
    command     = "./hack/vpa-down.sh"
    working_dir = "autoscaler/vertical-pod-autoscaler"
    when        = destroy
  }
}