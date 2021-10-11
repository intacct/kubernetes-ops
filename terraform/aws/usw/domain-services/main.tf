provider "aws" {
  profile = var.auth_profile
  region  = var.region
}



################################################################################
# VPC Module
################################################################################

module "vpc" {
  # source = "../../modules/multi-region/vpc-v2"
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.7.0"



  create_vpc = var.create_vpc
  # name_prefix = var.name_prefix
  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c", "${var.region}d"]
  private_subnets = var.private_subnets
  # private_subnet_names = var.private_subnet_names
  public_subnets = var.public_subnets
  
  enable_nat_gateway  = true
  single_nat_gateway  = true
  one_nat_gateway_per_az = false
  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module

  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  tags = {
    Owner       = "devops"
    Environment = "sandbox"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

}

resource "aws_eip" "nat" {
  count = 4

  vpc = true
}

# module "vpc" {
#   source = "../../modules/multi-region/vpc-2"

#   # The rest of arguments are omitted for brevity

#   enable_nat_gateway  = true
#   single_nat_gateway  = false
#   one_nat_gateway_per_az = true
#   reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
#   external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module
# }

module "ecr_repository" {
  source                  = "../../modules/multi-region/ecr"
  create_repository       = var.create_repository
  repository_names        = var.repository_names
  attach_lifecycle_policy = var.attach_lifecycle_policy
}

module "service_users" {
  source                  = "../../modules/multi-region/iam-user"
  name                    = var.service_users
  force_destroy           = true
  create_user             = true
  create_iam_user_login_profile = false
  create_iam_access_key   = true

  pgp_key                 = var.pgp_key
  password_length         = var.password_len
  password_reset_required = false
}
module "console_users" {
  source                  = "../../modules/multi-region/iam-user"
  name                    = var.console_users
  force_destroy           = true
  create_user             = true
  create_iam_user_login_profile = true
  create_iam_access_key   = true

  pgp_key                 = var.pgp_key
  password_length         = var.password_len
  password_reset_required = false
}

module "ecr_group" {
    source = "../../modules/multi-region/iam-group"
    create_group = true
    name = var.ecr_group_name
    group_users = var.ecr_users
    custom_group_policy_arns          = [
      module.iam_policy.arn
    ]
    attach_iam_self_management_policy = true
}

module "iam_policy" {
  source  = "../../modules/multi-region/iam-policy"

  name        = var.policy_name
  path        = var.policy_path
  description = "Provides full access to billing-integration bucket via the AWS Management Console"
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions   = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:ListImages",
      "ecr:UploadLayerPart",
      "ecr:GetAuthorizationToken"
    ]
    effect    = "Allow"
    resources = [
      # "arn:aws:ecr:us-east-1:374322211295:repository/ia-ds-template"
      module.ecr_repository.repository.arn,
      "*"
    ]
  }
}

# module "iam_role" {
#   source = "../../modules/multi-region/iam-role"
#   # version = "~> 2.0"
  
#   name  = var.role_name
#   path  = var.role_path
#   # custom_iam_policy_arns = [
#   #   module.iam_policy_glue.arn
#   # ]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
#   target_policy_name = var.role_policy_name
#   target_policy = data.aws_iam_policy_document.service-role-s3-policy.json

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "glue.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# module "jmphost-instance" {
#   source = "../../modules/multi-region/ec2"

#   instance_count = length(var.hostnames)

#   name          = var.instance_name 
#   use_name_prefix = var.use_name_prefix
#   name_prefix   = var.ec2_name_prefix
#   use_num_suffix = var.use_num_suffix
#   ami           = var.ami
#   instance_type = var.instance_type
#   subnet_id     = module.vpc.private_subnets[0]
#   private_ips   = var.private_ips
#   hostnames     = var.hostnames
#   vpc_security_group_ids = [module.sg.this_security_group_id]
#   associate_public_ip_address = true
#   # exec_script   = var.exec_script 
#   key_name      = var.key_name
#   key_file      = var.key_file

#   # user_data_base64 = base64encode(local.user_data)

#   root_block_device = [
#     {
#       volume_type = "gp2"
#       volume_size = 20
#     },
#   ]

#   ebs_block_device = var.ebs_devices
  
#   tags = {
#     "Env"      = "DevOps"
#     "Location" = var.region
#   }
# }

module "test-instance" {
  source = "../../modules/multi-region/ec2"

  instance_count = 1

  name          = "test01"
  use_name_prefix = true
  name_prefix   = var.ec2_name_prefix
  use_num_suffix = var.use_num_suffix
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnets[0]
  private_ips   = ["10.52.0.11"]
  hostnames     = ["test01"]
  vpc_security_group_ids = [module.sg.this_security_group_id]
  associate_public_ip_address = false
  # exec_script   = var.exec_script 
  key_name      = var.key_name
  key_file      = var.key_file

  # user_data_base64 = base64encode(local.user_data)

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
    },
  ]

  ebs_block_device = var.ebs_devices
  
  tags = {
    "Env"      = "DevOps"
    "Location" = var.region
  }
}

module "sg" {
  source = "../../modules/multi-region/security-group"

  create                 = true
  # name                   = format("%s-%s",var.name_prefix, var.sg_name)
  name                   = var.sg_name
  description            = var.sg_description
  vpc_id                 = module.vpc.vpc_id
  tags                   = {
      Name = var.sg_name
  }

  ##########
  # Ingress
  ##########
  # Rules by names - open for default CIDR
  ingress_with_cidr_blocks = concat(
    local.security_groups["default_inbound"],
    local.security_groups["custom_inbound"],
  )

  egress_rules = ["all-all"]
}

locals {
  security_groups = {
    default_inbound = var.default_inbound
    default_outbound = var.default_outbound
    custom_inbound = var.custom_inbound
    custom_outbound = var.custom_outbound
  }
}


resource "aws_vpc_peering_connection" "this" {
  peer_owner_id = var.peer_acc_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.owner_vpc_id
  # auto_accept   = true

  tags = {
    Name = "ia-ds-vpc-peering-vpc-ops"
  }
}

resource "aws_route" "r1" {
  count = length(var.route_inst_cidr_block)
  route_table_id          = "rtb-06bff830f524c223d"
  destination_cidr_block  = element(var.route_inst_cidr_block, count.index)
  instance_id             = "i-0e7e6c5bdd966c007"
}
resource "aws_route" "r2" {
  route_table_id          = "rtb-06bff830f524c223d"
  destination_cidr_block  = "10.48.0.0/16"
  vpc_peering_connection_id = "pcx-0c10d8f33f74ecee2"
}
# resource "aws_route" "r3" {
#   route_table_id          = "rtb-06bff830f524c223d"
#   destination_cidr_block  = "172.16.0.0/12"
#   instance_id             = "i-0e7e6c5bdd966c007"
# }
# resource "aws_route" "r4" {
#   route_table_id          = "rtb-06bff830f524c223d"
#   destination_cidr_block  = "10.0.0.0/8"
#   instance_id             = "i-0e7e6c5bdd966c007"
# }


# data "aws_eks_cluster" "eks" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.cluster_id
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks.token
# }

# module "eks" {
#   source          = "../../modules/multi-region/terraform-aws-eks"

#   cluster_version = "1.21"
#   cluster_name    = var.eks_cluster_name
#   vpc_id          = module.vpc.vpc_id
#   subnets         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

#   worker_groups = [
#     {
#       instance_type = "m4.large"
#       asg_max_size  = 5
#     }
#   ]
# }

#
# EKS
#


module "eks" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/eks?ref=v1.0.25"
  aws_region = var.region
  tags       = var.tags

  cluster_name = var.eks_environment_name

  vpc_id         = module.vpc.vpc_id
  k8s_subnets    = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  public_subnets = [module.vpc.public_subnets[0]]

  cluster_version                = "1.18"
  cluster_endpoint_public_access = false
  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0"
  ]

  # private cluster - kubernetes API is internal the the VPC
  cluster_endpoint_private_access                = true
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
    "100.64.0.0/16",
  ]




  map_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
  map_users = [
    {
      userarn  = "arn:aws:iam::725654443526:user/username"
      username = "username"
      groups   = ["system:masters"]
    },
  ]

  node_groups = {
    ng1 = {
      disk_size        = 20
      desired_capacity = 4
      max_capacity     = 4
      min_capacity     = 2
      instance_types   = ["t3.small"]
      additional_tags  = var.tags
      k8s_labels       = {}
    }
  }

  # depends_on = [
  #   module.vpc
  # ]
}


data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = "intacct"
    workspaces = {
      name = "usw-domain_services"
    }
  }
}


# EKS authentication
# https://registry.terraform.io/providers/hashicorp/helm/latest/docs#exec-plugins
provider "helm" {
  kubernetes {
    # host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    # cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }

    
  }
}


#
# EKS authentication
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#exec-plugins
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
  }
}

#
# Helm - kube-prometheus-stack
#
module "kube-prometheus-stack" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/kube-prometheus-stack?ref=v1.0.9"

  helm_values = file("${path.module}/helm/kube-prometheus-stack/values.yaml")

  depends_on = [
    data.terraform_remote_state.eks
  ]
}

#
# Helm - grafana-loki-stack
#
# Doc: https://github.com/grafana/helm-charts/tree/main/charts/loki-stack
module "loki" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.9"

  repository          = "https://grafana.github.io/helm-charts"
  official_chart_name = "loki-stack"
  user_chart_name     = "loki-stack"
  helm_version        = "2.3.1"
  namespace           = "monitoring"
  helm_values         = file("${path.module}/helm/grafana-loki/values.yaml")

  depends_on = [
    data.terraform_remote_state.eks
  ]
}


#
# Helm - istio
#
module "istio" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/istio?ref=v1.0.26"

  helm_values_istio_base = file("${path.module}/helm/istio/istio_base_values.yaml")
  helm_values_istiod     = file("${path.module}/helm/istio/istiod_values.yaml")
  helm_values_istio_ingress = file("${path.module}/helm/istio/istio_ingress_values.yaml")

  depends_on = [
    data.terraform_remote_state.eks
  ]
}


#
# Helm - kube-prometheus-stack
#
module "kubernetes-external-secrets" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/kubernetes-external-secrets?ref=v1.0.20"

  eks_cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  helm_values                 = file("${path.module}/helm/kube-external-secrets/values.yaml")
  environment_name            = var.eks_environment_name
  secrets_prefix              = "ia-ds"

  depends_on = [
    data.terraform_remote_state.eks
  ]
}


#
# Route53 Hosted Zone
#
module "route53-hostedzone" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/route53/hosted-zone?ref=v1.0.19"

  domain_name = var.domain_name
  tags        = var.tags
}


#
# Helm - cluster-autoscaler
#
module "external-dns" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/external-dns?ref=v1.0.28"

  aws_region                  = var.region
  cluster_name                = var.eks_environment_name
  eks_cluster_id              = module.eks.cluster_id
  eks_cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  route53_hosted_zones        = module.route53-hostedzone.zone_id
  helm_values_2               = file("${path.module}/helm/external-dns/values.yaml")

#  depends_on = [
#    data.terraform_remote_state.eks
#  ]
}


#
# Helm - cluster-autoscaler
#
module "cert-manager" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/cert-manager?ref=v1.0.29"

  aws_region                  = var.region
  cluster_name                = var.eks_environment_name
  eks_cluster_id              = module.eks.cluster_id
  eks_cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  route53_hosted_zones        = module.route53-hostedzone.zone_id
  domain_name                 = var.domain_name
  lets_encrypt_email          = var.lets_encrypt_email
  helm_values_2               = file("${path.module}/helm/cert-manager/values.yaml")

#  depends_on = [
#    data.terraform_remote_state.eks
#  ]
}


#
# Helm - cluster-autoscaler
#
module "cluster-autoscaler" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/cluster-autoscaler?ref=v1.0.12"

  aws_region                  = var.region
  cluster_name                = var.eks_environment_name
  eks_cluster_id              = module.eks.cluster_id
  eks_cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

#  depends_on = [
#    data.terraform_remote_state.eks
#  ]
}
output "output_console_user_name" {
    value = module.console_users.this_iam_user_name
}
output "output_console_user_encrypted_password" {
    value = module.console_users.this_iam_user_login_profile_encrypted_password
}
output "output_console_user_encrypted_password_cmd" {
    value = module.console_users.keybase_password_decrypt_command
}
output "output_console_user_access_key" {
    value = module.console_users.this_iam_access_key_id
}
output "output_console_user_encrypted_secred" {
    value = module.console_users.this_iam_access_key_encrypted_secret
}
# output "output_iam_user_secret_key_cmd" {
#     value = module.iam_user.keybase_secret_key_decrypt_command
# }
output "output_service_user_name" {
    value = module.service_users.this_iam_user_name
}
output "output_service_user_encrypted_password" {
    value = module.service_users.this_iam_user_login_profile_encrypted_password
}
output "output_service_user_encrypted_password_cmd" {
    value = module.service_users.keybase_password_decrypt_command
}
output "output_service_user_access_key" {
    value = module.service_users.this_iam_access_key_id
}
output "output_service_user_encrypted_secred" {
    value = module.service_users.this_iam_access_key_encrypted_secret
}

output "output_vpc" {
    value = module.vpc.vpc_arn
}