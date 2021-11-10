###############################
# Paths
###############################
base_path        = "terraform/aws/domain-services"

###############################
# Env Name
###############################
environment_name = "dev"

###############################
# Common tags
###############################
environment_tags = {
  ops_managed_by  = "terraform",
  ops_source_repo = "do-infrastructure",
  ops_owners      = "devops",
}
