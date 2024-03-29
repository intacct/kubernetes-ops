output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = var.vpc_cidr
}

output "private_subnets" {
  description = "A list of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnet_arns" {
  description = "A list of private subnets"
  value       = module.vpc.private_subnet_arns
}

output "public_subnets" {
  description = "A list of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnet_arns" {
  description = "A list of public subnets"
  value       = module.vpc.public_subnet_arns
}

output "k8s_subnets" {
  description = "A list of private k8s subnets"
  value       = module.vpc.elasticache_subnets
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.vpc.public_route_table_ids
}

output "security_groups" {
  description = "List of ARN's for the Security Groups"
  value       = module.security-group.*
}

