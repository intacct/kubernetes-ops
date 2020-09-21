provider "aws" {
    region = "us-west-2"
    profile = "2auth"
}

module "sg" {
  source = "../../../modules/multi-region/security-group"

  create                 = true
  name                   = "mongo-repl1-tf"
  use_name_prefix        = false
  description            = "Mongo replicaset 1 Security Group"
  vpc_id                 = "vpc-48c2bd2e"
  tags                   = {
      Name = "mongo-repl1-tf"
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
      from_port   = 10050
      to_port     = 10050
      protocol    = "tcp"
      description = "zabbix-eng"
      cidr_blocks = "192.168.20.21/32"
    },
    {
      from_port   = 8008
      to_port     = 8009
      protocol    = "tcp"
      description = "JMX, RMI ports for monitoring from zabbix-eng"
      cidr_blocks = "192.168.20.21/32"
    },
    {
      from_port   = 10050
      to_port     = 10050
      protocol    = "tcp"
      description = "usw-zbx"
      cidr_blocks = "10.234.5.14/32"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = "Replicaset nodes"
      cidr_blocks = "10.234.8.0/24"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = ""
      cidr_blocks = "10.234.1.0/24"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = ""
      cidr_blocks = "10.234.4.0/24"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = ""
      cidr_blocks = "10.226.16.0/23"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = ""
      cidr_blocks = "10.226.72.0/23"
    },
  ]

  #########
  # Egress
  #########
  # Rules by names - open for default CIDR
  egress_rules = ["all-all"]
}