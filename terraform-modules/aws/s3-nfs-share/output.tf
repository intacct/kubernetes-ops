output "ec2_sgw_private_ip" {
  value       = module.ec2_sgw.private_ip
  description = "The Private IP address of the Storage Gateway on EC2"
  sensitive = true
}

output "storage_gateway" {
  value       = module.sgw.storage_gateway
  description = "Storage Gateway Module"
  sensitive   = true
}

output "storage_gateway_name" {
  value       = module.sgw.storage_gateway_name
  description = "Storage Gateway Name"
}

output "nfs_share_arn" {
  value       = module.nfs_share.nfs_share_arn
  description = "The ARN of the created NFS File Share."
}

output "nfs_share_path" {
  value       = module.nfs_share.nfs_share_path
  description = "The path of the created NFS File Share."
}