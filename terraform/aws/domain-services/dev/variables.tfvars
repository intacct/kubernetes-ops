###############################
# Paths
###############################
base_path        = "terraform/aws/domain-services/dev"
base_env_name    = "dev"

###############################
# Common tags
###############################
environment_tags = {
  ops_managed_by  = "terraform",
  ops_source_repo = "do-infrastructure",
  ops_owners      = "devops",
}
