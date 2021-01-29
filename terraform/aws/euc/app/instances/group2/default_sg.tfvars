  default_ingress_rules = [
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
      description = "all http"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "all https"
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
      description = "euc-zbx"
      cidr_blocks = "10.235.4.10/32"
    },
    {
      from_port   = 8008
      to_port     = 8009
      protocol    = "tcp"
      description = "JMX, RMI ports for monitoring from euc-zbx"
      cidr_blocks = "10.235.4.10/32"
    },
    {
      # Ephemeral ports for inbound traffic for outbound connections
      from_port   = 32768
      to_port     = 65535
      protocol    = "tcp"
      description = "Ephemeral ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  #########
  # Egress
  #########
  # Rules by names - open for default CIDR
#   default_egress_rules = [
#     {
#         from_port = 0
#         to_port   = 0
#         protocol  = -1
#         description = "Ananke opens tcp/udp on 53, 111, 123, 910"
#         cidr_blocks = "192.168.20.13/32"
#     },
#     {
#         from_port = 0
#         to_port   = 0
#         protocol  = -1
#         description = "AD Controllers Radius 1812-1813, LDAP 389, LDAPS 636"
#         cidr_blocks = "10.226.12.12/30"
#     },
#     {
#       # Ephemeral ports for inbound traffic for outbound connections
#       from_port   = 32768
#       to_port     = 65535
#       protocol    = "tcp"
#       description = "Ephemeral ports"
#       cidr_blocks = "0.0.0.0/0"
#     }
#   ]


  default_egress_rules = ["all-all"]

