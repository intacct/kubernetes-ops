resource "null_resource" "vpa_deployment" {
  provisioner "local-exec" {
    when        = create
    command = <<EOF
      git clone https://github.com/kubernetes/autoscaler.git
      cd autoscaler/vertical-pod-autoscaler/
      ./hack/vpa-up.sh
    EOF
  }

  provisioner "local-exec" {
    command     = "./hack/vpa-down.sh"
    working_dir = "autoscaler/vertical-pod-autoscaler"
    when        = destroy
  }

  # Dummy input variable to trigger re-provisioning
  input_variables = {
    trigger = timestamp()
  }
}

# resource "null_resource" "vpa_deployment" {
#   provisioner "local-exec" {
#     command = <<EOF
#       git clone https://github.com/kubernetes/autoscaler.git
#       cd autoscaler/vertical-pod-autoscaler/
#       ./hack/vpa-up.sh
#     EOF
#   }
# }