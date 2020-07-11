# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.this_subnets_cidr_blocks
}

# Subnets
output "subnets" {
  description = "List of IDs of subnets"
  value       = module.vpc.this_subnets
}

# Network ACLs
output "this_network_acl_id" {
  description = "ID of the network ACL"
  value       = module.vpc.this_network_acl_id
}

output "module_vpc" {
  description = "Module VPC"
  value       = module.vpc
}