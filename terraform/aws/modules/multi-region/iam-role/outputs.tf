
output "this_role_name" {
  description = "IAM role name"
  value       = element(concat(aws_iam_role.this.*.name, [var.name]), 0)
}
