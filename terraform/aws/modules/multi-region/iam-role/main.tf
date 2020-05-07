locals {
  role_name = element(concat(aws_iam_role.this.*.id, [var.name]), 0)
}

resource "aws_iam_role" "this" {
    name                = var.name
    assume_role_policy  = var.assume_role_policy
    tags                = {
        name = var.name
    }
    path                = var.path
}

# resource "aws_iam_policy_attachment" "this" {
#   count = length(var.custom_iam_policy_arns) > 0 ? length(var.custom_iam_policy_arns) : 0

#   name  = var.policy_attachment_name
#   roles = ["${aws_iam_role.this.name}"]
#   policy_arn = element(var.custom_iam_policy_arns, count.index)
# }

resource "aws_iam_role_policy_attachment" "this" {
    role = "${aws_iam_role.this.id}"
    policy_arn = var.policy_arn
}

resource "aws_iam_role_policy" "this" {
  name = var.target_policy_name
  role = "${aws_iam_role.this.id}"
  policy = var.target_policy
}

