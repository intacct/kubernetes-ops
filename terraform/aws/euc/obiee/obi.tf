/* Create OBIEE Server on AWS
*/

provider "aws" {
  profile = "2auth"
  region = var.region
}

resource "aws_subnet" "euc-obi-snet" {
  vpc_id     = var.vpc
  cidr_block = var.subnet

  tags = {
    Name = "obiee"
  }
}

resource "aws_network_acl" "euc-jgl-nacl" {
  vpc_id    = var.vpc
  subnet_ids = ["${aws_subnet.euc-obi-snet.id}",]

  ingress {
    # Allow ICMP traffic to server for ping and traceroute functions
    rule_no     = 100
    action      = "allow"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
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
    # Allows inbound return traffic from hosts on internet that are responding to requests originating in the subnet
    rule_no     = 150
    action      = "allow"
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0" 
  }
  ingress {
    # Open port for servers to access Oracle RDS
    rule_no     = 160
    action      = "allow"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  ingress {
    # Allow inbound RDP traffic from home network
    rule_no     = 170
    action      = "allow"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
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
  # Open port for DNS resolution
  egress {
    rule_no     = 130
    action      = "allow"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  # Open port for DNS resolution
  egress {
    rule_no     = 140
    action      = "allow"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_block  = "0.0.0.0/0"
  }

  tags = {
    Name = "obiee"
  }
}

resource "aws_security_group" "euc-obi-sg" {
  name        = "euc_obi"
  description = "Port definitions for EUC OBIEE servers"
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

  egress {
    # Allow all outbound traffic
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "obiee"
  }
}

resource "aws_instance" "euc-obi" {
  subnet_id                   = "${aws_subnet.euc-obi-snet.id}"
  instance_type               = var.instance_type
  vpc_security_group_ids      = ["${aws_security_group.euc-obi-sg.id}"]
  associate_public_ip_address = false
  count                       = 2
  private_ip                  = "${lookup(var.ips,count.index)}"
  ami                         = var.ami
  key_name                    = var.keyname

  lifecycle {
    prevent_destroy = true
    ignore_changes = [ami,tags,]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = false  
  }

  # /u01 => 20G
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = false
  }
  # /u02 -> 200G
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_type           = "gp2"
    volume_size           = 200
    delete_on_termination = false
  }

  tags = {
    Name = "${element(var.instance_tags, count.index)}"
  }
}
