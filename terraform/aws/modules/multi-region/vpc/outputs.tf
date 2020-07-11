output "this_subnets" {
  description = "List of IDs of subnets"
  value       = aws_subnet.this.*.id
}

output "this_subnet_arns" {
  description = "List of ARNs of  subnets"
  value       = aws_subnet.this.*.arn
}

output "this_subnets_cidr_blocks" {
  description = "List of cidr_blocks of subnets"
  value       = aws_subnet.this.*.cidr_block
}

output "this_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of subnets in an IPv6 enabled VPC"
  value       = aws_subnet.this.*.ipv6_cidr_block
}

output "this_network_acl_id" {
  description = "ID of the network ACL"
  value       = concat(aws_network_acl.this.*.id, [""])[0]
}

# Static values (arguments)
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}