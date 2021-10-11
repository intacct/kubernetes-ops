# output "arn" {
#   value       = aws_ecr_repository.default[0]
#   description = "Full ARN of the repository"
# }
output "repository" {
  description = "All outputs of the repository."
  value       = try(aws_ecr_repository.default[0], null)
}
# output "name" {
#   value       = aws_ecr_repository.default.name
#   description = "Name of the repository"
# }

# output "registry_id" {
#   value       = aws_ecr_repository.default.registry_id
#   description = "Registry ID where the repository was created"
# }

# output "repository_url" {
#   value       = aws_ecr_repository.default.repository_url
#   description = "URL of the repository"
# }