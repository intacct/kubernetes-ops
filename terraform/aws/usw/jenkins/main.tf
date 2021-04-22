/*
 * Create HAProxy Servers 
*/
provider "aws" {
  profile = var.auth_profile
  region  = var.region
}

resource "aws_security_group" "usw-ci-sg" {
  name        = "usw-ci-sg"
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
  ingress {
      # Allow JMX, RMI ports for monitoring
      description = "JMX RMI Ports for monitoring"
      from_port   = 8008
      to_port     = 8009
      protocol    = "tcp"
      cidr_blocks = ["192.168.20.21/32"]
  }
  ingress {
      description = "NFS"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      description = "Docker"
      from_port   = 4243
      to_port     = 4243
      protocol    = "tcp"
      cidr_blocks = ["10.234.4.0/24"]
  }
  ingress {
      description = "Docker"
      from_port   = 4243
      to_port     = 4243
      protocol    = "tcp"
      cidr_blocks = ["10.226.16.0/24"]
  }
  ingress {
      description = "Grafana"
      from_port   = 3001
      to_port     = 3001
      protocol    = "tcp"
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
    Name = "usw-ci-sg"
  }
}

resource "aws_instance" "usw-ci" {
  subnet_id                   = var.subnet
  instance_type               = var.instance_type
  vpc_security_group_ids      = ["${aws_security_group.usw-ci-sg.id}"]
  associate_public_ip_address = false
  count                       = 2
  private_ip                  = "${element(var.ips,count.index)}"
  ami                         = var.ami
  key_name                    = var.keyname

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = false  
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

  tags = {
    Name = "${element(var.hostnames, count.index)}"
  }

  provisioner "local-exec" {
    command = <<EOT
ssh-add ${var.key_file}
ansible-playbook -i "${element(var.hostnames, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/zabbix-agent.yml" --extra-vars "hosts_var=${element(var.hostnames, count.index)} remote_user_var=centos become_var=yes"
ansible-playbook -i "${element(var.hostnames, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/sysadmin-config.yml" --extra-vars "hosts_var=${element(var.hostnames, count.index)} remote_user_var=centos become_var=yes"
EOT
  }
}
