/*
 * Create External Zabbix Server  
*/

provider "aws" {
  profile = "2auth"
  region = var.region
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
    description = "Zabbix inseure portal/dashboard port"
    from_port   = 80
    to_port     = 80
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
  count = length(var.ips)
  subnet_id                   = var.subnet
  instance_type               = "t2.large"
  vpc_security_group_ids      = ["${aws_security_group.monitoring_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "${element(var.ips, count.index)}"
  ami                         = "${element(var.ami, count.index)}"
  key_name                    = "sridhar.krishnamurthy"

  tags = {
    Name = "${element(var.hostnames, count.index)}"
  }

  provisioner "local-exec" {
      command = <<EOT
sed '/^${element(var.ips,count.index)}/d' ~/.ssh/known_hosts > /tmp/kh
sed '/^${element(var.hostnames,count.index)}/d' /tmp/kh > /tmp/kh2
mv /tmp/kh2 ~/.ssh/known_hosts
EOT
  }

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname ${element(var.hostnames, count.index)}"]
  }

  connection {
    host  = "${element(var.ips,count.index)}"
    type = "ssh"
    user = "centos"
    private_key = "${file(var.key_file)}"
  }

  provisioner "local-exec" {
    command = <<EOT
ssh-add var.key_file
ansible-playbook -i "${element(var.hostnames, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/sysadmin-config.yml" --extra-vars "hosts_var=${element(var.hostnames, count.index)} remote_user_var=centos become_var=yes"
EOT
  }
}