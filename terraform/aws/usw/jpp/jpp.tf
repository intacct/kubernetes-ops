/*
 * Create JPP Servers 
*/
# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "~> 2.50"
#     }
#   }
# }

provider "aws" {
  region  = var.region
  profile = "2auth"
  # shared_credentials_file = "/Users/skrishnamurthy/.aws/credentials"
}

resource "aws_subnet" "jpp" {
  vpc_id     = var.vpc
  cidr_block = var.subnet

  tags = {
    Name = "dev_jpp"
  }
}


resource "aws_security_group" "jpp_sg" {
  name        = "dev_jpp_sg"
  description = "Port definitions for Dev JPP server"
  vpc_id      = var.vpc

  ingress {
    # The port used for listening for requests (/xml/xmlgw.phtml and /info).
    description = "Open port for service requests"
    from_port   = 8070
    to_port     = 8070
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # The port used for commands except stop and forced stop (all interfaces except 
    # /xml/xmlgw.phtml and /info).
    description = "Open port for commands"
    from_port   = 8071
    to_port     = 8071
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # The port used for stop and forced stop commands.
    description = "Open port for stop cmd"
    from_port   = 8072
    to_port     = 8072
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # This port is used for JMX monitoring of JPP service
    description = "Open port for JMX monitoring"
    from_port   = 8074
    to_port     = 8074
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
    Name = "jpp_sg"
  }
}

resource "aws_instance" "dev_jpp01" {
  subnet_id                   = "${aws_subnet.jpp.id}"
  instance_type               = "t2.large"
  vpc_security_group_ids      = ["${aws_security_group.jpp_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "10.234.10.5"
  ami                         = var.ami
  key_name                    = "sridhar.krishnamurthy"

  tags = {
    Name = "dev_jpp01"
  }
}
