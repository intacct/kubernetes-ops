/*
 * Create HAProxy Servers 
*/
provider "aws" {
  profile = "2auth"
  region = var.region
}

resource "aws_subnet" "euc-jgl-snet" {
  vpc_id     = var.vpc
  cidr_block = var.subnet

  tags = {
    Name = "juggler"
  }
}

resource "aws_network_acl" "euc-jgl-nacl" {
  vpc_id    = var.vpc
  subnet_ids = ["${aws_subnet.euc-jgl-snet.id}",]

  ingress {
    # Allow ICMP traffic to server for ping and traceroute functions
    rule_no     = 100
    action      = "allow"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    icmp_type   = -1
    icmp_code   = -1
    cidr_block  = "0.0.0.0/0"
  }
  ingress {
    # Open SSH port
    rule_no     = 110
    action      = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  ingress {
    # Open HTTP port
    rule_no     = 120
    action      = "allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block = "0.0.0.0/0"
  }  
  ingress {
    # Open HTTP port
    rule_no     = 130
    action      = "allow"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_block = "0.0.0.0/0"
  }    
  ingress {
    # Open HTTPS port
    rule_no     = 140
    action      = "allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  ingress {
    rule_no     = 150
    action      = "allow"
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" 
  }
  ingress {
    # Open port for DNS server
     rule_no    = 160
     action     = "allow"
     from_port  = 0
     to_port    = 0
     protocol   = -1
     cidr_block = "192.168.20.13/32"
  }  
  egress {
    rule_no     = 100
    action      = "allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  egress {
    rule_no     = 110
    action      = "allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  egress {
    rule_no     = 120
    action      = "allow"
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  egress {
    rule_no     = 130
    action      = "allow"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  egress {
    rule_no     = 140
    action      = "allow"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_block  = "0.0.0.0/0"
  }
  egress {
    # Allow ICMP traffic to server for ping and traceroute functions
    rule_no     = 150
    action      = "allow"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    icmp_type   = -1
    icmp_code   = -1
    cidr_block  = "0.0.0.0/0"
  }

  tags = {
    Name = "juggler"
  }
}

resource "aws_security_group" "euc-jgl-sg" {
  name        = "euc-jgl"
  description = "Port definitions for HAProxy server"
  vpc_id      = var.vpc

  ingress {
    # Open SSH port
    description = "HTTPS Port"
    from_port   = 443
    to_port     = 443
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

  egress {
    # Allow all outbound traffic
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "juggler"
  }
}

resource "aws_instance" "euc-jgl" {
  subnet_id                   = "${aws_subnet.euc-jgl-snet.id}"
  instance_type               = var.instance_type
  vpc_security_group_ids      = ["${aws_security_group.euc-jgl-sg.id}"]
  associate_public_ip_address = false
  count                       = 1
  private_ip                  = "${lookup(var.ips,count.index)}"
  ami                         = var.ami
  key_name                    = var.keyname

  lifecycle {
    prevent_destroy = true
    ignore_changes = [ami,tags,]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true  
  }

  tags = {
    Name = "${element(var.instance_tags, count.index)}"
  }
}
