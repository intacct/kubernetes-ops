provider "aws" {
    region = var.region
    profile = var.profile
}

module "vpc" {
  source = "../../../modules/multi-region/vpc"

  create_subnet              = false
  create_default_network_acl = false
  create_network_acl         = true
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.subnet_id
  name                       = var.name
  subnet_suffix              = var.subnet_suffix

  
  inbound_acl_rules = concat(
    local.network_acls["default_inbound"],
    local.network_acls["public_inbound"],
  )
  outbound_acl_rules = concat(
    local.network_acls["default_outbound"],
    local.network_acls["public_outbound"],
  )

  subnet_tags = {
    Name = format("%s-%s", var.name, "tf")
  }
  tags = {
    Owner       = "devops"
    Environment = "devops"
  }
}

locals {
  network_acls = {
    default_inbound = var.default_inbound
    
    # [
    #   {
    #     # ICMP ping requests
    #     rule_number = 100
    #     rule_action = "allow"
    #     icmp_code   = -1
    #     icmp_type   = -1
    #     protocol    = "icmp"
    #     cidr_block  = "0.0.0.0/0"
    #   },       
    #   {
    #     # SSH
    #     rule_number = 110
    #     rule_action = "allow"
    #     from_port   = 22
    #     to_port     = 22
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     rule_number = 120
    #     rule_action = "allow"
    #     from_port   = 80
    #     to_port     = 80
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     rule_number = 130
    #     rule_action = "allow"
    #     from_port   = 8080
    #     to_port     = 8080
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     rule_number = 140
    #     rule_action = "allow"
    #     from_port   = 443
    #     to_port     = 443
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     # DNS - 123, NIS - 910, SunRPC - 111 Server requests from ananke
    #      rule_number = 150
    #      rule_action = "allow"
    #      from_port   = 53
    #      to_port     = 910
    #      protocol    = "-1"
    #      cidr_block  = "192.168.20.13/32"
    #   },
    #   {
    #     # Radius TCP/UDP requests from 10.226.12.13, 10.226.12.14
    #      rule_number = 160
    #      rule_action = "allow"
    #      from_port   = 1812
    #      to_port     = 1813
    #      protocol    = "-1"
    #      cidr_block  = "10.226.12.13/30"
    #   },
    #   {
    #     # Port for Zabbix server zabbix-eng
    #     rule_number = 170
    #     rule_action = "allow"
    #     from_port   = 10050
    #     to_port     = 10050
    #     protocol    = "tcp"
    #     cidr_block  = "192.168.20.21/32"
    #   },
    #   {
    #     # JMX, RMI Ports for monitoring from zabbix-eng
    #     rule_number = 180
    #     rule_action = "allow"
    #     from_port   = 8008
    #     to_port     = 8009
    #     protocol    = "tcp"
    #     cidr_block  = "192.168.20.21/32"
    #   },
    #   {
    #     # Ephemeral ports for inbound traffic for outbound connections
    #     rule_number = 190
    #     rule_action = "allow"
    #     from_port   = 32768
    #     to_port     = 65535
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    # ]
    
    default_outbound = var.default_outbound
    
    # [
    #   {
    #     # ICMP ping requests
    #     rule_number = 100
    #     rule_action = "allow"
    #     icmp_code   = -1
    #     icmp_type   = -1
    #     protocol    = "icmp"
    #     cidr_block  = "0.0.0.0/0"
    #   },       
    #   {
    #     # SSH
    #     rule_number = 110
    #     rule_action = "allow"
    #     from_port   = 22
    #     to_port     = 22
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     rule_number = 120
    #     rule_action = "allow"
    #     from_port   = 80
    #     to_port     = 80
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     rule_number = 130
    #     rule_action = "allow"
    #     from_port   = 8080
    #     to_port     = 8080
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     rule_number = 140
    #     rule_action = "allow"
    #     from_port   = 443
    #     to_port     = 443
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     # DNS - 123, NIS - 910, SunRPC - 111 Server requests from ananke
    #      rule_number = 150
    #      rule_action = "allow"
    #      from_port   = 53
    #      to_port     = 910
    #      protocol    = "-1"
    #      cidr_block  = "192.168.20.13/32"
    #   },
    #   {
    #     # Radius TCP/UDP requests from 10.226.12.13, 10.226.12.14
    #      rule_number = 160
    #      rule_action = "allow"
    #      from_port   = 1812
    #      to_port     = 1813
    #      protocol    = "-1"
    #      cidr_block  = "10.226.12.13/30"
    #   },
    #   {
    #     # Port for Zabbix server zabbix-eng
    #     rule_number = 170
    #     rule_action = "allow"
    #     from_port   = 10050
    #     to_port     = 10050
    #     protocol    = "tcp"
    #     cidr_block  = "192.168.20.21/32"
    #   },
    #   {
    #     # JMX, RMI Ports for monitoring from zabbix-eng
    #     rule_number = 180
    #     rule_action = "allow"
    #     from_port   = 8008
    #     to_port     = 8009
    #     protocol    = "tcp"
    #     cidr_block  = "192.168.20.21/32"
    #   },
    #   {
    #     # Ephemeral ports for inbound traffic for outbound connections
    #     rule_number = 190
    #     rule_action = "allow"
    #     from_port   = 32768
    #     to_port     = 65535
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     # NTP traffic
    #     rule_number = 200
    #     rule_action = "allow"
    #     from_port   = 123
    #     to_port     = 123
    #     protocol    = "udp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    # ]

    public_inbound = var.public_inbound
    
    # [
    #   {
    #     # NFS
    #     rule_number = 500
    #     rule_action = "allow"
    #     from_port   = 2049
    #     to_port     = 2049
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    #   {
    #     # Port to Zabbix server euc-zbx01
    #     rule_number = 550
    #     rule_action = "allow"
    #     from_port   = 10050
    #     to_port     = 10050
    #     protocol    = "tcp"
    #     cidr_block  = "10.235.4.10/32"
    #   },
    #   {
    #     # JMX, RMI Ports for monitoring
    #     rule_number = 600
    #     rule_action = "allow"
    #     from_port   = 8008
    #     to_port     = 8009
    #     protocol    = "tcp"
    #     cidr_block  = "10.235.4.10/32"
    #   },
    # ]

    public_outbound = var.public_outbound
    
    # [
    #   {
    #     # Allow connections to all subnet
    #     rule_number     = 100
    #     rule_action     = "allow"
    #     from_port       = 0
    #     to_port         = 0
    #     protocol        = -1
    #     cidr_block      = "0.0.0.0/0"
    #   },

    # ]
  }
}
