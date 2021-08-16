provider "aws" {
    region = var.region
    profile = var.profile
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
EOF
}

module "instance" {
  source = "../../../../modules/multi-region/ec2"

  instance_count = length(var.hostnames)

  name          = var.instance_name 
  use_name_prefix = var.use_name_prefix
  name_prefix   = var.name_prefix
  use_num_suffix = var.use_num_suffix
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  private_ips   = var.private_ips
  hostnames     = var.hostnames
  vpc_security_group_ids = [module.sg.this_security_group_id]
  associate_public_ip_address = false
  exec_script   = var.exec_script 
  key_name      = var.key_name
  key_file      = var.key_file

  # user_data_base64 = base64encode(local.user_data)

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
    },
  ]

  ebs_block_device = var.ebs_devices
  
  tags = {
    "Env"      = "DevOps"
    "Location" = var.region
  }
}

module "sg" {
  source = "../../../../modules/multi-region/security-group"

  create                 = var.create_sg
  # name                   = format("%s-%s",var.name_prefix, var.sg_name)
  name                   = var.sg_name
  description            = var.sg_description
  vpc_id                 = var.vpc_id
  tags                   = {
      Name = var.sg_name
  }

  ##########
  # Ingress
  ##########
  # Rules by names - open for default CIDR
#   ingress_cidr_blocks      = ["0.0.0.0/0", "0.0.0.0/0", "192.168.20.21/32"]
#   ingress_rules            = ["all-icmp", "ssh-tcp", "zabbix-eng"]
  ingress_with_cidr_blocks = concat(
    local.security_groups["default_inbound"],
    local.security_groups["custom_inbound"],
  )

  egress_rules = ["all-all"]
}

locals {
  security_groups = {
    default_inbound = var.default_inbound
    default_outbound = var.default_outbound
    custom_inbound = var.custom_inbound
    custom_outbound = var.custom_outbound
  }
}

output "output_instance" {
  value = module.instance
}
output "output_sg" {
    value = module.sg
}
