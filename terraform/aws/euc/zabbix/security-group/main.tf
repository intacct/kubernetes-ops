provider "aws" {
    region = "us-west-2"
    profile = "2auth"
}

module "sg" {
  source = "../../../modules/multi-region/security-group"

  create                 = true
  name                   = "zabbix-tf"
  use_name_prefix        = false
  description            = "Zabbix Security Group"
  vpc_id                 = "vpc-48c2bd2e"
  tags                   = {
      Name = "zabbix-tf"
  }

  ##########
  # Ingress
  ##########
  # Rules by names - open for default CIDR
#   ingress_cidr_blocks      = ["0.0.0.0/0", "0.0.0.0/0", "192.168.20.21/32"]
#   ingress_rules            = ["all-icmp", "ssh-tcp", "zabbix-eng"]
  ingress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      description = "All IPV4 ICMP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "all ssh"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "zabbix portal http port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "zabbix portal https port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10050
      to_port     = 10050
      protocol    = "tcp"
      description = "Zabbix server to active communication port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10051
      to_port     = 10051
      protocol    = "tcp"
      description = "Zabbix active agent to zabbix server communication happens on this port"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  #########
  # Egress
  #########
  # Rules by names - open for default CIDR
  egress_rules = ["all-all"]
}