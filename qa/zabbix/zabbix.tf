/*
 * Create External Zabbix Server  
*/

provider "aws" {
  profile = "2auth"
  region = var.region
}

resource "aws_subnet" "monitoring_snet" {
  vpc_id     = var.vpc
  cidr_block = var.subnet

  tags = {
    Name = "dev-monitoring"
  }
}

resource "aws_security_group" "monitoring_sg" {
  name        = "dev_monitoring_sg"
  description = "Port definitions for Dev Monitoring Server group"
  vpc_id      = var.vpc

  ingress {
    # Need to confirm if this port need to be opened on server. 
    description = "Zabbix server to active communication port"
    from_port   = 10050
    to_port     = 10050
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Zabbix active agent to zabbix server communication happens on this port"
    from_port   = 10051
    to_port     = 10051
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Zabbix portal/dashboard port"
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
    Name = "dev-monitoring-sg"
  }
}

resource "aws_instance" "zbx-01" {
  subnet_id                   = aws_subnet.monitoring_snet.id
  instance_type               = "t2.large"
  vpc_security_group_ids      = ["${aws_security_group.monitoring_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "10.234.15.5"
  ami                         = var.ami
  key_name                    = "sridhar.krishnamurthy"

  tags = {
    Name = "usw-zbx-01"
  }
}
