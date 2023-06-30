# resource "null_resource" "vpa_deployment" {
#   provisioner "local-exec" {
#     command = <<EOF
#       git clone https://github.com/kubernetes/autoscaler.git
#       cd autoscaler/vertical-pod-autoscaler/
#       ./hack/vpa-up.sh
#     EOF
#   }
# }
# locals {
#   current_time      = time()                                  # Current time
#   destroy_threshold = timestampadd("10m", local.current_time) # Add 10 minutes to current time

#   should_destroy = local.current_time > local.destroy_threshold  # Compare current time with destroy threshold
# }

# # Conditional resource block to run destroy only if the null_resource was created earlier
# resource "null_resource" "vpa_destroy" {
#   count = local.should_destroy ? 1 : 0  # Run destroy only if should_destroy is true

#   provisioner "local-exec" {
#     command     = "./hack/vpa-down.sh"
#     working_dir = "autoscaler/vertical-pod-autoscaler"
#   }
# }

resource "null_resource" "vpa_deployment" {
  provisioner "local-exec" {
    command = <<EOF
      git clone https://github.com/kubernetes/autoscaler.git
      cd autoscaler/vertical-pod-autoscaler/
      ./hack/vpa-up.sh
    EOF
  }
}