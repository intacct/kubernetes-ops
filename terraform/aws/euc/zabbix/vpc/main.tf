provider "aws" {
    region = "eu-central-1"
    profile = "2auth"
}

module "vpc" {
  source = "../../../modules/multi-region/vpc"

  create_subnet = false
  create_default_network_acl = false
  create_network_acl = true
  vpc_id = "vpc-4b8def20"
  subnet_ids = ["subnet-2fea7852"]
  name = "monitoring-tf"
  subnet_suffix = "2fea7852"

  
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
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        # Port for Zabbix server zabbix-eng
        rule_number = 850
        rule_action = "allow"
        from_port   = 10050
        to_port     = 10050
        protocol    = "tcp"
        cidr_block  = "192.168.20.21/32"
      },
      {
        # Port to Zabbix server euc-zbx01
        rule_number = 860
        rule_action = "allow"
        from_port   = 10050
        to_port     = 10050
        protocol    = "tcp"
        cidr_block  = "10.235.4.10/32"
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
        # DNS - 123, NIS - 910, SunRPC - 111 Server requests
         rule_number = 880
         rule_action = "allow"
         from_port   = 0
         to_port     = 0
         protocol    = "-1"
         cidr_block  = "192.168.20.13/32"
      },
      {
        # JMX, RMI Ports for monitoring
        rule_number = 890
        rule_action = "allow"
        from_port   = 8008
        to_port     = 8009
        protocol    = "tcp"
        cidr_block  = "192.168.20.21/32"
      },
      {
        # JMX, RMI Ports for monitoring
        rule_number = 900
        rule_action = "allow"
        from_port   = 8008
        to_port     = 8009
        protocol    = "tcp"
        cidr_block  = "10.235.4.10/32"
      },
      {
        # Radius requests 10.226.12.12, 10.226.12.14
         rule_number = 910
         rule_action = "allow"
         from_port   = 1812
         to_port     = 1812
         protocol    = "-1"
         cidr_block  = "10.226.12.12/30"
      },
    ]
    default_outbound = [
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
      {
        # Port for Zabbix server zabbix-eng
        rule_number = 200
        rule_action = "allow"
        from_port   = 10051
        to_port     = 10051
        protocol    = "tcp"
        cidr_block  = "192.168.20.21/32"
      },

    ]
    public_outbound = [
      {
        # Allow db connections to oracle subnet
        rule_number     = 100
        rule_action     = "allow"
        from_port       = 0
        to_port         = 65535
        protocol        = "all"
        cidr_block      = "0.0.0.0/0"
      },
    ]
  }
}
