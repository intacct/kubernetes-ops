# Vars that need to be localized
region          = "us-west-2"
name_prefix     = "usw"
vpc_id          = "vpc-48c2bd2e"
subnet_suffix   = "sn-5db7"
subnet_id       = "subnet-ec035db7"
private_ips     = ["10.234.2.16"]
key_name        = "sridhar.krishnamurthy"
key_file        = "/Users/skrishnamurthy/.aws/sridharkrishnamurthy.pem"
ami             = "ami-0157b1e4eefd91fd7" // Centos 8.2
security_group_id = "sg-0c7fd535b054d41ae"

profile         = "2auth"
instance_count  = 1
use_name_prefix = true
instance_name   = "gdb"
use_num_suffix  = true
instance_type   = "m5a.4xlarge"
hostnames       = ["gdb02"]
exec_script     = "./attach_ebs.sh"
sg_name         = "db-tf"

ebs_block_devices = [
    {
      # u01
      device_name = "/dev/sdb"
      volume_type = "gp2"
      volume_size = 100
      delete_on_termination = true
    },
    {
      # u02
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 200
      delete_on_termination = true
    },
    {
      # u03
      device_name = "/dev/sdg"
      volume_type = "gp2"
      volume_size = 500
      delete_on_termination = true
    },
    {
      # var
      device_name = "/dev/sdh"
      volume_type = "gp2"
      volume_size = 10
      delete_on_termination = true
    },
  ]