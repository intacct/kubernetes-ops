region            = "us-west-2"
auth_profile      = "2auth"

##################
# Elastic Container Repository
##################
create_repository = true
repository_names  = [
    "ia-ds-template",
]
attach_lifecycle_policy = false

##################
# IAM User
##################
user_names = [
    "alexandru.talmaciu",
  ] 

##################
# IAM Group
##################
group_name = "ia-domain-services" 

##################
# IAM Policy
##################
policy_name = "ia-domain-services"
policy_path = "/"
