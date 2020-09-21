    custom_inbound = [
      {
        # EUC App Subnet
        rule_number = 500
        rule_action = "allow"
        from_port   = 5044
        to_port     = 5044
        protocol    = "tcp"
        cidr_block  = "10.235.0.0/24"
      }, 
      {
        # EUC App Subnet
        rule_number = 510
        rule_action = "allow"
        from_port   = 9200
        to_port     = 9200
        protocol    = "tcp"
        cidr_block  = "10.235.0.0/24"
      }, 
    ]
    custom_outbound = []
