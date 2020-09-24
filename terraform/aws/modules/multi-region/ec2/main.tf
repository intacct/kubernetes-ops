locals {
  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami              = var.ami
  instance_type    = var.instance_type
  user_data        = null == var.exec_script ? var.user_data : file(var.exec_script)
  # user_data_base64 = var.user_data_base64
  subnet_id = length(var.network_interface) > 0 ? null : element(
    distinct(compact(concat([var.subnet_id], var.subnet_ids))),
    count.index,
  )
  key_name               = var.key_name
  monitoring             = var.monitoring
  get_password_data      = var.get_password_data
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile

  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = length(var.private_ips) > 0 ? element(var.private_ips, count.index) : var.private_ip
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  ebs_optimized = var.ebs_optimized

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy

  tags = merge(
    {
      "Name" = var.use_name_prefix ? format("${var.name_prefix_format}%s", var.name_prefix, element(var.hostnames, count.index)) : element(var.hostnames, count.index)
    },
    var.tags,
  )

  volume_tags = merge(
    {
      "Name" = var.instance_count > 1 || var.use_num_suffix ? format("%s${var.num_suffix_format}", element(var.hostnames, count.index), count.index + 1) : element(var.hostnames, count.index)
    },
    var.volume_tags,
  )

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  // Remove instance entry in ~/.ssh/known_hosts in case the instance was redeployed 
  provisioner "local-exec" {
      command = <<EOT
sed '/^${element(var.private_ips,count.index)}/d' ~/.ssh/known_hosts > /tmp/kh
sed '/^${var.use_name_prefix ? format("${var.name_prefix_format}%s", var.name_prefix, element(var.hostnames, count.index)) : element(var.hostnames, count.index)}/d' /tmp/kh > /tmp/kh2
mv /tmp/kh2 ~/.ssh/known_hosts
EOT
  }

  // Set hostname on the provisioned instance
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${var.use_name_prefix ? format("${var.name_prefix_format}%s.%s", var.name_prefix, element(var.hostnames, count.index), var.domain_suffix) : format("%s.%s",element(var.hostnames, count.index), var.domain_suffix)}",
      "sudo dnf -y update",
      "sudo dnf -y install firewalld",
      "sudo systemctl start firewalld",
      "sudo systemctl enable firewalld"
    ]
  }
  connection {
    host  = element(var.private_ips,count.index)
    type = "ssh"
    user = "centos"
    private_key = file(var.key_file)
    timeout = "10m"
  }

  // Call Ansible Playbook to run sysadmin-confign playbook on the provisioned instance
  provisioner "local-exec" {
    command = <<EOT
ssh-add "${var.key_file}"
ansible-playbook -i "${var.use_name_prefix ? format("${var.name_prefix_format}%s", var.name_prefix, element(var.hostnames, count.index)) : element(var.hostnames, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/zabbix-agent.yml" --extra-vars "hosts_var=${var.use_name_prefix ? format("${var.name_prefix_format}%s", var.name_prefix, element(var.hostnames, count.index)) : element(var.hostnames, count.index)} remote_user_var=centos become_var=yes"
ansible-playbook -i "${var.use_name_prefix ? format("${var.name_prefix_format}%s", var.name_prefix, element(var.hostnames, count.index)) : element(var.hostnames, count.index)}", -v -K "/Users/skrishnamurthy/do-ansible/sysadmin-config.yml" --extra-vars "hosts_var=${var.use_name_prefix ? format("${var.name_prefix_format}%s", var.name_prefix, element(var.hostnames, count.index)) : element(var.hostnames, count.index)} remote_user_var=centos become_var=yes"
EOT
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

}