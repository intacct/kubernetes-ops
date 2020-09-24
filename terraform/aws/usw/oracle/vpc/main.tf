provider "aws" {
    region = "us-west-2"
    profile = "2auth"
}

module "vpc" {
  source = "../../../modules/multi-region/vpc"

  create_subnet = var.create_subnet
  create_default_network_acl = false
  create_network_acl = true
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_id
  name = var.subnet_name
  subnet_suffix = var.subnet_suffix
  subnets = var.subnets
  azs = var.azs

  
  inbound_acl_rules = concat(
    local.network_acls["default_inbound"],
    local.network_acls["public_inbound"],
  )
  outbound_acl_rules = concat(
    local.network_acls["default_outbound"],
    local.network_acls["public_outbound"],
  )

  subnet_tags = {
    Name = format("%s-%s", var.subnet_name, var.subnet_suffix)
  }
  tags = {
    Owner       = "devops"
    Environment = "devops"
  }
}

locals {
  network_acls = {
    default_inbound = var.default_inbound
    default_outbound = var.default_outbound
    public_inbound = var.custom_inbound
    public_outbound = var.custom_outbound
  }
}
