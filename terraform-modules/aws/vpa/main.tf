# resource "null_resource" "vpa_deployment" {
#   triggers = {
#     git_clone = module.git_clone.timestamp
#   }

#   provisioner "local-exec" {
#     command = <<EOF
#       git clone https://github.com/kubernetes/autoscaler.git
#       cd autoscaler/vertical-pod-autoscaler
#       ./hack/vpa-up.sh
#     EOF
#   }
# }

# module "git_clone" {
#   source = "cloudposse/git-archive/null"
#   version = "0.3.2"
#   repository = var.vpa_repo
#   output_path = var.output_path
# }
resource "null_resource" "vpa_deployment" {
  triggers = {
    file_changes = fileset(path.module, "vertical-pod-autoscaler/**")
  }

  provisioner "local-exec" {
    command = <<EOF
      cd vertical-pod-autoscaler
      ./hack/vpa-up.sh
    EOF
  }
}