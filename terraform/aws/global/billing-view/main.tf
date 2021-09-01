provider "aws" {
  profile = var.auth_profile
  region  = var.region
}


module "iam_group" {
    source = "../../modules/multi-region/iam-group"
    create_group = true
    name = var.group_name
    group_users = var.user_names
    custom_group_policy_arns          = [
      "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
    ]
    attach_iam_self_management_policy = true
}



