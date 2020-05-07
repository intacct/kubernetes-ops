/*
 * Create HAProxy Servers 
*/
provider "aws" {
  profile = "2auth"
  region = var.region
}

resource "aws_subnet" "usw-jgl-snet" {
  vpc_id     = var.vpc
  cidr_block = var.subnet

  tags = {
    Name = "usw-jgl-snet"
  }
}


resource "aws_security_group" "usw-jgl-sg" {
  name        = "usw-jgl-sg"
  description = "Port definitions for HAProxy server"
  vpc_id      = var.vpc

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
    # Open SSH port
    description = "HTTPS Port"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # Allow zabbix monitoring from zabbix-eng.intacct.com
    description = "Zabbix"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["192.168.20.21/32"]
  }
  ingress {
    # Allow zabbix monitoring from usw-zbx-01.intacct.com
    description = "Zabbix"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["10.234.5.14/32"]
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
    Name = "usw-jgl-sg"
  }
}

resource "aws_instance" "usw-jgl01" {
  subnet_id                   = "${aws_subnet.usw-jgl-snet.id}"
  instance_type               = "t2.large"
  vpc_security_group_ids      = ["${aws_security_group.usw-jgl-sg.id}"]
  associate_public_ip_address = false
  count                       = 1
  private_ip                  = "${lookup(var.ips,count.index)}"
  ami                         = var.ami
  key_name                    = var.keyname

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true  
  }

  tags = {
    Name = "${element(var.instance_tags, count.index)}"
  }
}
