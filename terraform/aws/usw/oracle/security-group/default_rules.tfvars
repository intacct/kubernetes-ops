default_inbound = [
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
    # {
    #     from_port   = 0
    #     to_port     = 0
    #     protocol    = "all"
    #     description = "DNS NIS SunRPC"
    #     cidr_blocks = "192.168.20.13/32"
    # },
    # {
    #     from_port   = 1812
    #     to_port     = 1813
    #     protocol    = "tcp"
    #     description = "NIS"
    #     cidr_blocks = "10.226.12.12/30"
    # },
    # {
    #     from_port   = 1812
    #     to_port     = 1813
    #     protocol    = "udp"
    #     description = "NIS"
    #     cidr_blocks = "10.226.12.12/30"
    # },
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
        description = "usw-zbx"
        cidr_blocks = "10.234.5.14/32"
    },
]

default_outbound = []