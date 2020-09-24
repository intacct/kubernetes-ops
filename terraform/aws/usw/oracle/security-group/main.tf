provider "aws" {
    region = "us-west-2"
    profile = "2auth"
}

module "sg" {
  source = "../../../modules/multi-region/security-group"

  create      = var.create_sg
  name        = var.sg_name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = {
      Name = var.sg_name
  }

  # ingress_with_cidr_blocks = concat(
  #   local.sg_rules["default_inbound"],
  #   local.sg_rules["custom_inbound"],
  # )

  # egress_rules = concat(
  #   local.sg_rules["default_outbound"],
  #   local.sg_rules["custom_outbound"],
  # )
  ingress_with_cidr_blocks = concat(
    var.default_inbound,
    var.custom_inbound,
  )

  egress_rules = concat(
    var.default_outbound,
    var.custom_outbound,
  )
}

output "output_sg" {
    value = module.sg
}

# locals {
#   sg_rules = {
#     default_inbound = var.default_inbound
#     default_outbound = var.default_outbound
#     custom_inbound = var.custom_inbound
#     custom_outbound = var.custom_outbound
#   }
# }

  ##########
  # Ingress
  ##########
  # Rules by names - open for default CIDR
#   ingress_cidr_blocks      = ["0.0.0.0/0", "0.0.0.0/0", "192.168.20.21/32"]
#   ingress_rules            = ["all-icmp", "ssh-tcp", "zabbix-eng"]
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = -1
#       to_port     = -1
#       protocol    = "icmp"
#       description = "All IPV4 ICMP"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "all ssh"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = 10050
#       to_port     = 10050
#       protocol    = "tcp"
#       description = "zabbix-eng"
#       cidr_blocks = "192.168.20.21/32"
#     },
#     {
#       from_port   = 8008
#       to_port     = 8009
#       protocol    = "tcp"
#       description = "JMX, RMI ports for monitoring from zabbix-eng"
#       cidr_blocks = "192.168.20.21/32"
#     },
#     {
#       from_port   = 10050
#       to_port     = 10050
#       protocol    = "tcp"
#       description = "usw-zbx"
#       cidr_blocks = "10.234.5.14/32"
#     },
#     {
#       from_port   = 1521
#       to_port     = 1521
#       protocol    = "tcp"
#       description = "usw app subnet"
#       cidr_blocks = "10.234.1.0/24"
#     },
#     {
#       from_port   = 1521
#       to_port     = 1521
#       protocol    = "tcp"
#       description = "usw obiee subnet"
#       cidr_blocks = "10.234.9.0/24"
#     },
#     {
#       from_port   = 1521
#       to_port     = 1521
#       protocol    = "tcp"
#       description = "usw ci subnet"
#       cidr_blocks = "10.234.4.0/24"
#     },
#     {
#       from_port   = 1521
#       to_port     = 1521
#       protocol    = "tcp"
#       description = "usw aux subnet"
#       cidr_blocks = "10.234.5.0/24"
#     },
#   ]

#   #########
#   # Egress
#   #########
#   # Rules by names - open for default CIDR
#   egress_rules = ["all-all"]
# }