# resource "aws_network_acl" "this" {
#   count      = var.create_nacl ? 1 : 0
#   vpc_id     = var.vpc
#   subnet_ids = [var.subnet]

#   # ingress {
#   #   # Allow ICMP traffic to server for ping and traceroute functions
#   #   rule_no     = 100
#   #   action      = "allow"
#   #   from_port   = 8
#   #   to_port     = 8
#   #   protocol    = "icmp"
#   #   icmp_type   = -1
#   #   icmp_code   = -1
#   #   cidr_block  = "0.0.0.0/0"
#   # }
#   ingress {
#     # Open SSH port
#     rule_no     = 110
#     action      = "allow"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   ingress {
#     # Open HTTP port
#     rule_no     = 120
#     action      = "allow"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_block = "0.0.0.0/0"
#   }  
#   ingress {
#     # Open HTTP port
#     rule_no     = 130
#     action      = "allow"
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_block = "0.0.0.0/0"
#   }    
#   ingress {
#     # Open HTTPS port
#     rule_no     = 140
#     action      = "allow"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   ingress {
#     # Allows inbound return traffic from hosts on internet that are responding to requests originating in the subnet
#     rule_no     = 150
#     action      = "allow"
#     from_port   = 32768
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0" 
#   }
#   ingress {
#     # Open port for servers to access Oracle RDS
#     rule_no     = 160
#     action      = "allow"
#     from_port   = 1521
#     to_port     = 1521
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   ingress {
#     # Allow inbound traffic from usw-zbx-01 to local Zabbix agent
#     rule_no     = 170
#     action      = "allow"
#     from_port   = 10050
#     to_port     = 10050
#     protocol    = "tcp"
#     cidr_block  = "192.168.20.21/32"
#   }
#   ingress {
#     # Allow inbound traffic from usw-zbx-01 to local Zabbix agent
#     rule_no     = 180
#     action      = "allow"
#     from_port   = 10050
#     to_port     = 10050
#     protocol    = "tcp"
#     cidr_block  = "10.234.5.14/32"
#   }
#   ingress {
#     # Forward requests from usw-jgl01
#     rule_no     = 190
#     action      = "allow"
#     from_port   = 5700
#     to_port     = 5702
#     protocol    = "tcp"
#     cidr_block  = "10.234.11.10/32"
#   }  
#   ingress {
#     # Open port for DNS server
#      rule_no    = 200
#      action     = "allow"
#      from_port  = 0
#      to_port    = 0
#      protocol   = -1
#      cidr_block = "192.168.20.13/32"
#   }
#   egress {
#     rule_no     = 100
#     action      = "allow"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   egress {
#     rule_no     = 110
#     action      = "allow"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   egress {
#     rule_no     = 120
#     action      = "allow"
#     from_port   = 32768
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   # Open port for DNS resolution
#   egress {
#     rule_no     = 130
#     action      = "allow"
#     from_port   = 53
#     to_port     = 53
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   # Open port for DNS resolution
#   egress {
#     rule_no     = 140
#     action      = "allow"
#     from_port   = 53
#     to_port     = 53
#     protocol    = "udp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   # egress {
#   #   # Allow ICMP traffic to server for ping and traceroute functions
#   #   rule_no     = 150
#   #   action      = "allow"
#   #   from_port   = 0
#   #   to_port     = 0
#   #   protocol    = "icmp"
#   #   icmp_type   = -1
#   #   icmp_code   = -1
#   #   cidr_block  = "0.0.0.0/0"
#   # }
#   egress {
#     # Allow db connections to oracle subnet
#     rule_no     = 160
#     action      = "allow"
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_block  = "10.234.2.0/24"
#   }
#   egress {
#     # Allow db connections to oracle subnet
#     rule_no     = 170
#     action      = "allow"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_block  = "0.0.0.0/0"
#   }
#   egress {
#     # Allow db connections to CI oracle subnet
#     rule_no     = 180
#     action      = "allow"
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_block  = "10.226.17.0/24"
#   }
#   egress {
#     # Allow NTP traffic
#     rule_no     = 190
#     action      = "allow"
#     from_port   = 123
#     to_port     = 123
#     protocol    = "udp"
#     cidr_block  = "0.0.0.0/0"
#   }

#   tags = {
#     Name = var.nacl_name
#   }
# }

resource "aws_security_group" "this" {
  count = var.create_security_group ? 1 : 0
  name        = var.sg_name
  description = "Port definitions for USW Oracle GDB servers"
  vpc_id      = var.vpc

  ingress {
    # Open port for servers to access Oracle RDS
    description = "Oracle server port"
    from_port   = 1521
    to_port     = 1521
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # Open SSH port
    description = "SSH port"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # Allow ICMP traffic to server for ping and traceroute functions
    description = "ICMP port"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # Open port for Zabbix
    description = "Zabbix"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["192.168.20.21/32"]
  }
  ingress {
    description = "Zabbix"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["10.234.5.14/32"]
  }
  ingress {
    description = "Forward requests from usw-jgl*"
    from_port   = 5700
    to_port     = 5702
    protocol    = "tcp"
    cidr_blocks = ["10.234.11.10/32"]
  }

  egress {
    # Allow all outbound traffic
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }

}

resource "aws_instance" "this" {
    count                       = var.create_instance ? length(var.ips) : 0    
    subnet_id                   = var.subnet
    instance_type               = var.instance_type
    vpc_security_group_ids      = var.create_security_group ? ["${aws_security_group.this[0].id}"] : var.security_group_ids
    associate_public_ip_address = false
    private_ip                  = element(var.ips,count.index)
    ami                         = var.ami
    key_name                    = var.key_name

  lifecycle {
    # prevent_destroy = true
    ignore_changes = [ami,tags,]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true  
  }

  # /u01 => 100G
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = var.u01_size
    delete_on_termination = true
  }
  # /u02 -> 200G
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_type           = "gp2"
    volume_size           = var.u02_size
    delete_on_termination = true
  }
  # /u03 -> 500G
  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_type           = "gp2"
    volume_size           = var.u03_size
    delete_on_termination = true
  }
  # /var -> 10G
  ebs_block_device {
    device_name           = "/dev/sdh"
    volume_type           = "gp2"
    volume_size           = var.var_size
    delete_on_termination = true
  }

  provisioner "local-exec" {
      command = <<EOT
sed '/^${element(var.ips,count.index)}/d' ~/.ssh/known_hosts > /tmp/kh
sed '/^${element(var.hostnames,count.index)}/d' /tmp/kh > /tmp/kh2
mv /tmp/kh2 ~/.ssh/known_hosts
EOT
  }

  # Run the attach_ebs.sh file as part of startup
  user_data = file(var.mount_script)

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname ${element(var.hostnames, count.index)}"]
  }

  connection {
    host  = element(var.ips,count.index)
    type = "ssh"
    user = "centos"
    private_key = file(var.key_file)
  }

  tags = {
    Name = element(var.hostnames, count.index)
  }

  provisioner "local-exec" {
    command = <<EOT
ssh-add "${var.key_file}"
ansible-playbook -i "${element(var.hostnames, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/sysadmin-config.yml" --extra-vars "hosts_var=${element(var.hostnames, count.index)} remote_user_var=centos become_var=yes"
EOT
  }
}
