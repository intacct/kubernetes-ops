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

resource "aws_network_acl" "euc-obi-nacl" {
  vpc_id    = var.vpc
  subnet_ids = ["${aws_subnet.euc-obi-snet.id}",]

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
  ingress {
    # Zabbix agent
    rule_no     = 180
    action      = "allow"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_block  = "192.168.20.21/32"
  }
  ingress {
    # Zabbix agent
    rule_no     = 190
    action      = "allow"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_block  = "10.234.5.14/32"
  }
  ingress {
    # Forward requests from euc-obi*
    rule_no     = 200
    action      = "allow"
    from_port   = 5700
    to_port     = 5702
    protocol    = "tcp"
    cidr_block  = "10.235.9.10/32"
  }
  ingress {
    # Open port for DNS server
     rule_no    = 210
     action     = "allow"
     from_port  = 0
     to_port    = 0
     protocol   = -1
     cidr_block = "192.168.20.13/32"
  }  
  ingress {
    # Open port for NTP traffic
     rule_no    = 220
     action     = "allow"
     from_port  = 123
     to_port    = 123
     protocol   = "udp"
     cidr_block = "0.0.0.0/0"
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
  egress {
    # Allow db connections to AWS oracle subnet
    rule_no     = 160
    action      = "allow"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_block  = "10.235.1.0/24"
  }
  egress {
    # Allow outbound SSH connections 
    rule_no     = 170
    action      = "allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
  }
  egress {
    # Allow db connections to CI oracle subnet
    rule_no     = 180
    action      = "allow"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_block  = "10.226.17.0/24"
  }
  egress {
    # Allow NTP traffic
    rule_no     = 190
    action      = "allow"
    from_port   = 123
    to_port     = 123
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
    cidr_blocks = ["10.235.9.10/32"]
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
  count                       = length(var.hostnames)
  private_ip                  = "${lookup(var.ips,count.index)}"
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
  # /u02 => 200G
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_type           = "gp2"
    volume_size           = 200
    delete_on_termination = false
  }

  provisioner "local-exec" {
      command = <<EOT
sed '/^${lookup(var.ips,count.index)}/d' ~/.ssh/known_hosts > /tmp/kh
sed '/^${element(var.hostnames,count.index)}/d' /tmp/kh > /tmp/kh2
mv /tmp/kh2 ~/.ssh/known_hosts
EOT
  }

  # Run the attach_ebs.sh file as part of startup
  
  # Use attach_ebs.sh if working on euc-obi2 and euc-obi3; as otherwise it will force destroy and recreate
  # Use attach_ebs_v2.sh if working on instances other than euc-obi2/euc-obi3
  # user_data = "${file("files/attach_ebs.sh")}"
  user_data = "${file("files/attach_ebs_v2.sh")}"

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname ${element(var.hostnames, count.index)}"]
  }

  connection {
    host  = "${element(var.hostnames, count.index)}"
    type = "ssh"
    user = "centos"
    private_key = "${file("~/.aws/sridharkrishnamurthy-frankfurt.pem")}"
  }

  tags = {
    Name = "${replace("${element(var.hostnames, count.index)}", ".intacct.com", "")}"
    # Name = "${regex("^.*?[^\.]*" "${element(var.hostnames, count.index)}")}"
  }

  provisioner "local-exec" {
    command = <<EOT
ssh-add var.key_file
ansible-playbook -i "${element(var.hostnames, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/sysadmin-config.yml" --extra-vars "hosts_var=${element(var.hostnames, count.index)} remote_user_var=centos become_var=yes"
EOT
  }

}

# resource "aws_ebs_volume" "euc-obi-u01" {
#   count             = length(var.instance_tags)
#   availability_zone = "${aws_instance.euc-obi[count.index].availability_zone}"
#   type              = "gp2"
#   size              = 20
# }

# resource "aws_ebs_volume" "euc-obi-u02" {
#   count             = length(var.instance_tags)
#   availability_zone = "${aws_instance.euc-obi[count.index].availability_zone}"
#   type              = "gp2"
#   size              = 200
# }

# resource "aws_volume_attachment" "euc-obi-u01-attachment" {
#   count        = length(var.instance_tags)
#   device_name  = "/dev/sdb"
#   # skip_destroy = true
#   force_detach = true
#   instance_id  = "${aws_instance.euc-obi[count.index].id}"
#   volume_id    = "${aws_ebs_volume.euc-obi-u01[count.index].id}"
# }

# resource "aws_volume_attachment" "euc-obi-u02-attachment" {
#   count        = length(var.instance_tags)
#   device_name  = "/dev/sdc"
#   # skip_destroy = true
#   force_detach = true
#   instance_id  = "${aws_instance.euc-obi[count.index].id}"
#   volume_id    = "${aws_ebs_volume.euc-obi-u02[count.index].id}"
# }

