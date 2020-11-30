/* Create OBIEE Server on AWS
*/

provider "aws" {
  profile = "2auth"
  region = var.region
}

resource "aws_security_group" "usw-obi-sg" {
  name        = "usw_obi"
  description = "Port definitions for USW OBIEE servers"
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
    # Open HTTPS port
    description = "HTTPS port"
    from_port   = 443
    to_port     = 443
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
    description = "Forward requests from euc-obi*"
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
    Name = "obiee"
  }
}

resource "aws_instance" "usw-obi" {
  subnet_id                   = var.subnet
  instance_type               = var.instance-type
  vpc_security_group_ids      = ["${aws_security_group.usw-obi-sg.id}"]
  associate_public_ip_address = false
  count                       = length(var.instance-tags)
  private_ip                  = lookup(var.ips,count.index)
  ami                         = var.ami
  key_name                    = var.keyname

  lifecycle {
    # prevent_destroy = true
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

  # Run the attach_ebs.sh file as part of startup
  user_data = file("files/attach_ebs.sh")

  # user_data = "${data.template_cloudinit_config.config.rendered}"

  # provisioner "remote-exec" {
  #   inline = ["sudo hostnamectl set-hostname ${element(var.instance-tags, count.index)}"]
  # }

  # connection {
  #   host  = "${element(var.instance-tags, count.index)}"
  #   type = "ssh"
  #   user = "centos"
  #   private_key = "${file("~/.aws/sridharkrishnamurthy.pem")}"
  # }

  // Remove instance entry in ~/.ssh/known_hosts in case the instance was redeployed 
  provisioner "local-exec" {
      command = <<EOT
sed '/^${lookup(var.ips,count.index)}/d' ~/.ssh/known_hosts > /tmp/kh
sed '/^${element(var.instance-tags, count.index)}/d' /tmp/kh > /tmp/kh2
mv /tmp/kh2 ~/.ssh/known_hosts
EOT
  }

  // Set hostname on the provisioned instance
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${format("%s.%s",element(var.instance-tags, count.index), var.domain_suffix)}",
      "sudo yum -y update",
      "sudo yum -y install firewalld",
      "sudo systemctl start firewalld",
      "sudo systemctl enable firewalld"
    ]
  }
  connection {
    host  = lookup(var.ips,count.index)
    type = "ssh"
    user = "centos"
    private_key = file(var.key_file)
    timeout = "10m"
  }

  // Call Ansible Playbook to run sysadmin-confign playbook on the provisioned instance
  provisioner "local-exec" {
    command = <<EOT
ssh-add "${var.key_file}"
ansible-playbook -i "${element(var.instance-tags, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/zabbix-agent.yml" --extra-vars "hosts_var=${element(var.instance-tags, count.index)} remote_user_var=centos become_var=yes"
ansible-playbook -i "${element(var.instance-tags, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/sysadmin-config.yml" --extra-vars "hosts_var=${element(var.instance-tags, count.index)} remote_user_var=centos become_var=yes"
EOT
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }


  tags = {
    Name = "${element(var.instance-tags, count.index)}"
  }
}
