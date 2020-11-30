    custom_inbound = [
      {
        # EUC App Subnet
        rule_number = 500
        rule_action = "allow"
        from_port   = 27000
        to_port     = 27050
        protocol    = "tcp"
        cidr_block  = "10.235.0.0/24"
      }, 
      {
        # EUC Mongo Subnet
        rule_number = 510
        rule_action = "allow"
        from_port   = 27000
        to_port     = 27050
        protocol    = "tcp"
        cidr_block  = "10.235.7.0/24"
      }, 
      {
        # EUC CI Subnet
        rule_number = 520
        rule_action = "allow"
        from_port   = 27000
        to_port     = 27050
        protocol    = "tcp"
        cidr_block  = "10.235.3.0/24"
      }, 
    ]
    custom_outbound = []
