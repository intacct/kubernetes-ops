default_inbound = [
    {
      # ICMP ping requests
      rule_number = 100
      rule_action = "allow"
      icmp_code   = -1
      icmp_type   = -1
      protocol    = "icmp"
      cidr_block  = "0.0.0.0/0"
    },       
    {
      # SSH
      rule_number = 110
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 120
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 130
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      # DNS - 123, NIS - 910, SunRPC - 111 Server requests from ananke, 53-910
        rule_number = 140
        rule_action = "allow"
        from_port   = 53
        to_port     = 910
        protocol    = "-1"
        cidr_block  = "192.168.20.13/32"
    },
    {
      # Radius TCP/UDP requests from 10.226.12.13, 10.226.12.14 1812-1813, 389, 636
        rule_number = 150
        rule_action = "allow"
        from_port   = 1812
        to_port     = 1813
        protocol    = "-1"
        cidr_block  = "10.226.12.12/30"
    },
    {
      # Ephemeral ports for inbound traffic for outbound connections
      rule_number = 160
      rule_action = "allow"
      from_port   = 32768
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      # Port for Zabbix server zabbix-eng
      rule_number = 170
      rule_action = "allow"
      from_port   = 10050
      to_port     = 10051
      protocol    = "tcp"
      cidr_block  = "192.168.20.21/32"
    },
    {
      # JMX, RMI Ports for monitoring from zabbix-eng
      rule_number = 180
      rule_action = "allow"
      from_port   = 8008
      to_port     = 8009
      protocol    = "tcp"
      cidr_block  = "192.168.20.21/32"
    },
    {
      # Port for Zabbix server usw-zbx01
      rule_number = 190
      rule_action = "allow"
      from_port   = 10050
      to_port     = 10051
      protocol    = "tcp"
      cidr_block  = "10.234.5.14/32"
    },
    {
      # JMX, RMI Ports for monitoring from zabbix-eng
      rule_number = 200
      rule_action = "allow"
      from_port   = 8008
      to_port     = 8009
      protocol    = "tcp"
      cidr_block  = "10.234.5.14/32"
    },
    {
      # LDAP
      rule_number = 210
      rule_action = "allow"
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      # LDAPS
      rule_number = 211
      rule_action = "allow"
      from_port   = 636
      to_port     = 636
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
  ]

default_outbound = [
    {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
    }
  ]
