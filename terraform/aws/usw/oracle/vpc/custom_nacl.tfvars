    custom_inbound = [
      {
        # USW App Subnet
        rule_number = 500
        rule_action = "allow"
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        cidr_block  = "10.234.1.0/24"
      }, 
      {
        # usw obiee Subnet
        rule_number = 510
        rule_action = "allow"
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        cidr_block  = "10.234.9.0/24"
      }, 
      {
        # USW ci Subnet
        rule_number = 520
        rule_action = "allow"
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        cidr_block  = "10.234.4.0/24"
      }, 
      {
        # USW aux Subnet
        rule_number = 530
        rule_action = "allow"
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        cidr_block  = "10.234.5.0/24"
      }, 
      {
        # USW VPN Subnet
        rule_number = 540
        rule_action = "allow"
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        cidr_block  = "10.228.2.0/24"
      }, 
      {
        # USW VPN Subnet
        rule_number = 550
        rule_action = "allow"
        from_port   = 1521
        to_port     = 1521
        protocol    = "tcp"
        cidr_block  = "10.228.3.0/24"
      }, 
    ]
    custom_outbound = []
