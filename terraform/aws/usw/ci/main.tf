provider "aws" {
  profile = var.auth_profile
  region  = var.region
}

module "ecr-repository" {
  source                  = "../../modules/multi-region/ecr"
  create_repository       = var.create_repository
  repository_name         = var.repository_name
  attach_lifecycle_policy = var.attach_lifecycle_policy
}