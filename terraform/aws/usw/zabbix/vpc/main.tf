provider "aws" {
    region = "us-west-2"
    profile = "2auth"
}

module "vpc" {
  source = "../../../modules/multi-region/vpc"

  create_subnet = false
  create_default_network_acl = false
  create_network_acl = true
  vpc_id = "vpc-48c2bd2e"
  subnet_ids = ["subnet-6489a23f"]
  name = "monitoring-tf"
  subnet_suffix = "6489a23f"

  
  inbound_acl_rules = concat(
    local.network_acls["default_inbound"],
    local.network_acls["public_inbound"],
  )
  outbound_acl_rules = concat(
    local.network_acls["default_outbound"],
    local.network_acls["public_outbound"],
  )

  subnet_tags = {
    Name = "monitoring-tf"
  }
  tags = {
    Owner       = "devops"
    Environment = "devops"
  }
}

locals {
  network_acls = {
    default_inbound = [
      {
        # ICMP (ping, etc..) requests
        rule_number = 800
        rule_action = "allow"
        icmp_code   = -1
        icmp_type   = -1
        protocol    = "icmp"
        cidr_block  = "0.0.0.0/0"
      },       
      {
        # SSH
        rule_number = 810
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 820
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 830
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 840
        rule_action = "allow"
        from_port   = 8008
        to_port     = 8009
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        # Port for Zabbix agent 
        rule_number = 850
        rule_action = "allow"
        to_port     = 10050
        from_port   = 10050
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        # Port to Zabbix server 
        rule_number = 860
        rule_action = "allow"
        from_port   = 10051
        to_port     = 10051
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 870
        rule_action = "allow"
        from_port   = 32768
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        # DNS Server requests
         rule_number = 880
         rule_action = "allow"
         from_port   = 0
         to_port     = 0
         protocol    = "-1"
         cidr_block  = "192.168.20.13/32"
      },
      {
        # Radius requests 10.226.12.13, 10.226.12.14
         rule_number = 890
         rule_action = "allow"
         from_port   = 1812
         to_port     = 1812
         protocol    = "-1"
         cidr_block  = "10.226.12.13/30"
      },

    ]
    default_outbound = [
      {
        rule_number = 800
        rule_action = "allow"
        icmp_code   = -1
        icmp_type   = -1
        protocol    = "icmp"
        cidr_block  = "0.0.0.0/0"
      },  
      {
        rule_number = 810
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 820
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 830
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 840
        rule_action = "allow"
        from_port   = 32768
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        # DNS resolution
        rule_number = 850
        rule_action = "allow"
        from_port   = 53
        to_port     = 53
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        # DNS resolution
        rule_number = 860
        rule_action = "allow"
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        # NTP traffic
        rule_number = 870
        rule_action = "allow"
        from_port   = 123
        to_port     = 123
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        # DNS Server requests
         rule_number = 880
         rule_action = "allow"
         from_port   = 0
         to_port     = 0
         protocol    = "-1"
         cidr_block  = "192.168.20.13/32"
      },
      {
        # Radius requests
         rule_number = 890
         rule_action = "allow"
         from_port   = 1812
         to_port     = 1812
         protocol    = "-1"
         cidr_block  = "10.226.12.13/30"
      },
    ]
    public_inbound = [
      {
        # To accommodate for rule used by usw-wsd instance 
        # Custom WSD Web Port
        rule_number = 100
        rule_action = "allow"
        from_port   = 1086
        to_port     = 1086
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    public_outbound = [
      {
        # Allow db connections to oracle subnet
        rule_number     = 100
        rule_action     = "allow"
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_block      = "0.0.0.0/0"
      },
    ]
  }
}
