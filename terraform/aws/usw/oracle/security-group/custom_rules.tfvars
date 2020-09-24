custom_inbound = [
    {
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        description = "usw app subnet"
        cidr_blocks = "10.234.1.0/24"
    },
    {
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        description = "usw obiee subnet"
        cidr_blocks = "10.234.9.0/24"
    },
    {
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        description = "usw ci subnet"
        cidr_blocks = "10.234.4.0/24"
    },
    {
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        cidr_blocks = "10.234.5.0/24"
        description = "usw aux subnet"
    },
]

custom_outbound = ["all-all"]
