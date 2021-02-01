custom_ingress_rules = [
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "NFS4 protocol"
      cidr_blocks = "10.235.0.0/24"
    },
    {
      from_port   = 20048
      to_port     = 20048
      protocol    = "tcp"
      description = "Remote Procedure Call Bind"
      cidr_blocks = "10.235.0.0/24"
    },
    {
      from_port   = 20048
      to_port     = 20048
      protocol    = "udp"
      description = "Remote Procedure Call Bind"
      cidr_blocks = "10.235.0.0/24"
    },
    {
      from_port   = 111
      to_port     = 111
      protocol    = "tcp"
      description = "NFS Mount Lock Daemon"
      cidr_blocks = "10.235.0.0/24"
    },
    {
      from_port   = 111
      to_port     = 111
      protocol    = "udp"
      description = "NFS Mount Lock Daemon"
      cidr_blocks = "10.235.0.0/24"
    },
]
custom_egress_rules  = []