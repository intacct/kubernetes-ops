resource "aws_iam_openid_connect_provider" "this" {
  count = var.create_identity_provider ? 1 : 0

  url = var.url

  client_id_list = var.client_id_list

  thumbprint_list = var.thumbprint_list

  tags = var.tags
}

module "iam_assumable_role_admin" {
  source                         = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                        = "5.33.1"
  create_role                    = true
  role_name                      = var.name
  provider_url                   = var.url
  role_policy_arns               = [aws_iam_policy.iam_policy.arn]
  oidc_fully_qualified_audiences = var.validate_audiences
  oidc_fully_qualified_subjects  = var.validate_conditions
  tags                           = var.tags

  dynamic "oidc_condition" {
    for_each = var.url

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      dynamic "condition" {
        for_each = length(var.validate_audiences) > 0 ? var.url : []

        content {
          test     = "StringEquals"
          variable = "${oidc_condition.value}:aud"
          values   = var.validate_audiences
        }
      }
    }
  }
}

resource "aws_iam_policy" "iam_policy" {
  name_prefix = var.name
  description = "IAM Policy for the Github OIDC Federation permissions"
  policy      = var.aws_policy_json
  tags        = var.tags
}