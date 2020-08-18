provider "aws" {
    region = "us-west-2"
    profile = "2auth"
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
EOF
}

module "mongo-instance" {
  source = "../../../modules/multi-region/ec2"

  instance_count = 3

  name          = "usw-dbmgo"
  use_num_suffix = true
  ami           = "ami-0157b1e4eefd91fd7" // Cenos 8 x86_64
  instance_type = "m5a.4xlarge"
#   subnet_id     = tolist(data.aws_subnet_ids.all.ids)[0]
  subnet_id     = "subnet-0992b0acef52a4103"
  private_ips   = ["10.234.8.13","10.234.8.14","10.234.8.15"]
  hostnames     = ["usw-dbmgo01","usw-dbmgo02","usw-dbmgo03"]
  vpc_security_group_ids      = [module.sg.this_security_group_id]
#   vpc_security_group_ids      = ["sg-0577fbc1f568ea3d5"]
  associate_public_ip_address = false
  exec_script               = "./attach_ebs.sh" 
  key_name        = "sridhar.krishnamurthy"
  key_file        = "/Users/skrishnamurthy/.aws/sridharkrishnamurthy.pem"
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
      volume_size = 16
      delete_on_termination = true
    #   encrypted   = false
    #   kms_key_id  = aws_kms_key.this.arn
    },
    {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 100
      delete_on_termination = true
    },
    {
      device_name = "/dev/sdg"
      volume_type = "gp2"
      volume_size = 12
      delete_on_termination = true
    },
    {
      device_name = "/dev/sdh"
      volume_type = "gp2"
      volume_size = 20
      delete_on_termination = true
    },
    {
      device_name = "/dev/sdi"
      volume_type = "gp2"
      volume_size = 8
      delete_on_termination = true
    },
  ]

  tags = {
    "Env"      = "DevOps"
    "Location" = "us-west-2"
  }
}

module "sg" {
  source = "../../../modules/multi-region/security-group"

  create                 = true
  name                   = "usw-mongo-tf"
  use_name_prefix        = false
  description            = "Mongo Security Group"
  vpc_id                 = "vpc-48c2bd2e"
  tags                   = {
      Name = "mongo-repl1-tf"
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
      from_port   = 10050
      to_port     = 10050
      protocol    = "tcp"
      description = "zabbix-eng"
      cidr_blocks = "192.168.20.21/32"
    },
    {
      from_port   = 8008
      to_port     = 8009
      protocol    = "tcp"
      description = "JMX, RMI ports for monitoring from zabbix-eng"
      cidr_blocks = "192.168.20.21/32"
    },
    {
      from_port   = 10050
      to_port     = 10050
      protocol    = "tcp"
      description = "usw-zbx"
      cidr_blocks = "10.234.5.14/32"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = "Replicaset nodes"
      cidr_blocks = "10.234.8.0/24"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = ""
      cidr_blocks = "10.234.1.0/24"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = ""
      cidr_blocks = "10.234.4.0/24"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = ""
      cidr_blocks = "10.226.16.0/23"
    },
    {
      from_port   = 27000
      to_port     = 27050
      protocol    = "tcp"
      description = ""
      cidr_blocks = "10.226.72.0/23"
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