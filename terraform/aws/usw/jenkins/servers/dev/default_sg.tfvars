default_inbound = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      description = "All IPV4 ICMP for ping"
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
      to_port     = 10051
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
      to_port     = 10051
      protocol    = "tcp"
      description = "usw-zbx"
      cidr_blocks = "10.234.5.14/32"
    },
    {
      from_port   = 8008
      to_port     = 8009
      protocol    = "tcp"
      description = "JMX, RMI ports for monitoring from usw-zbx"
      cidr_blocks = "10.234.5.14/32"
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
