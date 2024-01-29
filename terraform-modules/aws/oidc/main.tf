data "aws_iam_policy_document" "assume_role_with_oidc" {
  count = var.create_role ? 1 : 0

  dynamic "statement" {
    # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
    for_each = var.allow_self_assume_role ? [1] : []

    content {
      sid     = "ExplicitSelfRoleAssumption"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      condition {
        test     = "ArnLike"
        variable = "aws:PrincipalArn"
        values   = ["arn:${local.partition}:iam::${data.aws_caller_identity.current.account_id}:role${var.role_path}${local.role_name_condition}"]
      }
    }
  }

  dynamic "statement" {
    for_each = local.urls

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type = "Federated"

        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${local.aws_account_id}:oidc-provider/${statement.value}"]
      }

      dynamic "condition" {
        for_each = length(var.oidc_fully_qualified_subjects) > 0 ? local.urls : []

        content {
          test     = "StringEquals"
          variable = "${statement.value}:sub"
          values   = var.oidc_fully_qualified_subjects
        }
      }

      dynamic "condition" {
        for_each = length(var.oidc_subjects_with_wildcards) > 0 ? local.urls : []

        content {
          test     = "StringLike"
          variable = "${statement.value}:sub"
          values   = var.oidc_subjects_with_wildcards
        }
      }

      dynamic "condition" {
        for_each = length(var.oidc_fully_qualified_audiences) > 0 ? local.urls : []

        content {
          test     = "StringEquals"
          variable = "${statement.value}:aud"
          values   = var.oidc_fully_qualified_audiences
        }
      }
    }
  }
}

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
}

resource "aws_iam_policy" "iam_policy" {
  name_prefix = var.name
  description = "IAM Policy for the Github OIDC Federation permissions"
  policy      = var.aws_policy_json
  tags        = var.tags
}