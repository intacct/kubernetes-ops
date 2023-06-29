output "vpa_repository_url" {
  value = module.git_clone.repository
}

output "vpa_output_path" {
  value = module.git_clone.output_path
}

output "vpa_deployment_status" {
  value = "VPA Deployment Completed"
}