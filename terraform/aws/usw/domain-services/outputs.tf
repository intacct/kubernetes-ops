#
# eks
#
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

#
# Route53 Hosted Zone
#
output "zone_id" {
  description = "The hosted zone ID"
  value       = module.route53-hostedzone.zone_id
}

output "name_servers" {
  description = "The hosted zone name servers"
  value       = module.route53-hostedzone.name_servers
}

output "domain_name" {
  value = var.domain_name
}