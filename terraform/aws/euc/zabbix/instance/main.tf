provider "aws" {
    region = "eu-central-1"
    profile = "2auth"
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
EOF
}

module "zabbix-instance" {
  source = "../../../modules/multi-region/ec2"

  instance_count = 1

  name          = "euc-zbx01"
  use_num_suffix = true
  ami           = "ami-032025b3afcbb6b34" // Cenos 8 x86_64
  instance_type = "t2.large"
#   subnet_id     = tolist(data.aws_subnet_ids.all.ids)[0]
  subnet_id     = "subnet-2fea7852"
  private_ips   = ["10.235.4.10"]
  hostnames     = ["euc-zbx01"]
  vpc_security_group_ids      = [module.sg.this_security_group_id]
#   vpc_security_group_ids      = ["sg-0577fbc1f568ea3d5"]
  associate_public_ip_address = false
  exec_script               = "./attach_ebs.sh" 
  key_name        = "sridhar.krishnamurthy-frankfurt"
  key_file        = "/Users/skrishnamurthy/.aws/sridharkrishnamurthy-frankfurt.pem"
#   ansible_playbooks = ["/Users/skrishnamurthy/do-ansible/sysadmin-config.yml","/Users/skrishnamurthy/do-ansible/zabbix-agent.yml"]

  user_data_base64 = base64encode(local.user_data)

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdb"
      volume_type = "gp2"
      volume_size = 100
      delete_on_termination = true
    },
  ]

  tags = {
    "Env"      = "DevOps"
    "Location" = "eu-central-1"
  }
}

module "sg" {
  source = "../../../modules/multi-region/security-group"

  create                 = true
  name                   = "zabbix-tf"
  use_name_prefix        = false
  description            = "Zabbix Security Group"
  vpc_id                 = "vpc-4b8def20"
  tags                   = {
      Name = "zabbix-tf"
  }

  ##########
  # Ingress
  ##########
  # Rules by names - open for default CIDR
#   ingress_cidr_blocks      = ["0.0.0.0/0", "0.0.0.0/0", "192.168.20.21/32"]
#   ingress_rules            = ["all-icmp", "ssh-tcp", "zabbix-eng"]
  ingress_with_cidr_blocks = [
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
      description = "zabbix portal http"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "zabbix portal https"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10050
      to_port     = 10050
      protocol    = "tcp"
      description = "zabbix agent port"
      cidr_blocks = "192.168.20.21/32"
    },
    {
      from_port   = 10051
      to_port     = 10051
      protocol    = "tcp"
      description = "zabbix server port"
      cidr_blocks = "192.168.20.21/32"
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "DNS Server requests"
      cidr_blocks = "192.168.20.13/32"
    },
  ]

  #########
  # Egress
  #########
  # Rules by names - open for default CIDR
  egress_rules = ["all-all"]
}

output "output_sg" {
    value = module.sg
}