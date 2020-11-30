    custom_inbound = [
      {
        # USW jgl01
        rule_number = 500
        rule_action = "allow"
        from_port   = 5700
        to_port     = 5720
        protocol    = "tcp"
        cidr_block  = "10.234.11.10/32"
      }, 
    ]
    custom_outbound = []
