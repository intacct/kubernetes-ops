resource "aws_instance" "this" {
    count                       = var.create_instance ? length(var.ips) : 0    
    subnet_id                   = var.subnet
    instance_type               = var.instance_type
    vpc_security_group_ids      = var.sg_id
    associate_public_ip_address = false
    private_ip                  = "${element(var.ips,count.index)}"
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
  # /u02 -> 1000G
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_type           = "gp2"
    volume_size           = var.u02_size
    delete_on_termination = true
  }
  # /u03 -> 1500G
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
  user_data = "${file("../../modules/multi-region/oracle-db/files/attach_ebs.sh")}"

  # user_data = "${data.template_cloudinit_config.config.rendered}"

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
ssh-add var.key_file
ansible-playbook -i "${element(var.hostnames, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/sysadmin-config.yml" --extra-vars "hosts_var=${element(var.hostnames, count.index)} remote_user_var=centos become_var=yes"
EOT
  }

}