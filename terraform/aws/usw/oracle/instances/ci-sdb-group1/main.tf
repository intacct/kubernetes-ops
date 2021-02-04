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

  instance_count = var.instance_count

  name          = var.instance_name 
  use_name_prefix = var.use_name_prefix
  name_prefix   = var.name_prefix
  use_num_suffix = var.use_num_suffix
  ami           = var.ami // Cenos 8 x86_64
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  private_ips   = var.private_ips
  hostnames     = var.hostnames
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = false
  exec_script   = var.exec_script 
  key_name      = var.key_name
  key_file      = var.key_file
#   ansible_playbooks = ["/Users/skrishnamurthy/do-ansible/sysadmin-config.yml","/Users/skrishnamurthy/do-ansible/zabbix-agent.yml"]

  user_data_base64 = base64encode(local.user_data)

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
    },
  ]

  ebs_block_device = var.ebs_block_devices

  tags = {
    "Env"      = "DevOps"
    "Location" = var.region
  }
}
