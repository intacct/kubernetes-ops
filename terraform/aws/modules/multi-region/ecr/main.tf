#
# ECR Resources
#

resource "aws_ecr_repository" "default" {
  count = var.create_repository ? length(var.repository_names) : 0
  name = element(var.repository_names, count.index)

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "default" {
  count = var.attach_lifecycle_policy ? length(var.lifecycle_policy) : 0

  repository = aws_ecr_repository.default[count.index]
  # policy     = var.lifecycle_policy != "" ? var.lifecycle_policy : file("${path.module}/templates/default-lifecycle-policy.json.tpl")
  policy     = lookup(var.lifecycle_policy, count.index)
}