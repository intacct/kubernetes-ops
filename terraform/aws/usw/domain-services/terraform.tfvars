region            = "us-west-2"
auth_profile      = "dslocal"
# auth_profile      = "827126933480_AWSAdministratorAccess"
# auth_profile      = "ds-sandbox"
name_prefix       = "ia-ds"

##################
# VPC
##################
vpc_name = "vpc"
vpc_cidr = "10.52.0.0/16"
create_vpc = true


##################
# Subnets
##################
# private_subnet_names = ["snet", "snet", "snet"]
private_subnets = ["10.52.0.0/18", "10.52.64.0/18", "10.52.128.0/18"]
public_subnets  = ["10.52.224.0/19"]
intra_subnets   = ["10.52.192.0/19"]
route_inst_cidr_block  = ["192.168.0.0/16", "172.16.0.0/12", "10.0.0.0/8"]


##################
# Elastic Container Repository
##################
create_repository = true
repository_names  = [
    "ia-ds",
]
attach_lifecycle_policy = false

##################
# IAM User
##################
pgp_key       = "keybase:skrishnamurthy"
password_len  = 15
console_users = [
    "alexandru.talmaciu",
  ] 
service_users = [
    "ia-ds-ecr",
    "ia-jenkins"
  ]
ecr_users = [
    "alexandru.talmaciu",
    "ia-ds-ecr"
  ]


##################
# IAM ECR Group
##################
ecr_group_name = "ia-ds-ecr-group" 

##################
# IAM Policy
##################
policy_name = "ia-domain-services"
policy_path = "/"

##################
# EC2
##################

ec2_name_prefix = "usw-ds"
# vpc_id          = "vpc-48c2bd2e"?
# key_name        = "sridhar.krishnamurthy"
# key_file        = "/Users/skrishnamurthy/.aws/sridhar.krishnamurthy-sso.pem"
use_name_prefix = true
use_num_suffix  = true
# exec_script     = "./attach_ebs.sh"

# Vars that need to be updated per instance group
# subnet_suffix   = "sn-2813"?
# subnet_id       = "subnet-04d91dcebe5f42813"
sg_description  = "Security Group for Jump Host"
private_ips     = ["10.52.0.10"]
ami             = "ami-0923359e80cfe4623"
instance_name   = "jmp01"
instance_type   = "t3.xlarge"
hostnames       = ["jmp01"]
sg_name         = "jmp-tf"
ebs_devices     = []

##################
# VPC Peering
##################
# accepter_profile = ""
owner_vpc_id     = "vpc-05e939a0b246773e3"
peer_vpc_id  = "vpc-0423d618162cda69d"
peer_acc_id  = "144866517101"

# owner_vpc_id     = "vpc-05e939a0b246773e3"
eng_peer_vpc_id  = "vpc-48c2bd2e"
eng_peer_acc_id  = "374322211295"

##################
# EKS Cluster
##################
eks_cluster_name = "dev"
eks_environment_name = "dev"

##################
# Hosted zone
##################
domain_name = "ds-dev.intacct.com"


##################
# Cert manager
##################
lets_encrypt_email = "sridhar.krishnamurthy@sage.com"