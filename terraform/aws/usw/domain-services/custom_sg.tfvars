    custom_inbound = [
        {
        from_port   = 53
        to_port     = 53
        protocol    = "tcp"
        description = "dns"
        cidr_blocks = "10.52.0.0/16"
        },
        {
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        description = "dns"
        cidr_blocks = "10.52.0.0/16"
        },
        {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        description = "ssh"
        cidr_blocks = "10.52.0.0/16"
        },
        {
        from_port   = 9080
        to_port     = 9080
        protocol    = "tcp"
        description = "db-proxy"
        cidr_blocks = "10.52.0.0/16"
        },

    ]
    custom_outbound = []
