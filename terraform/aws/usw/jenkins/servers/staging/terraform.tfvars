# Vars that don't need to be touched for usw
region          = "us-west-2"
name_prefix     = "usw"
vpc_id          = "vpc-48c2bd2e"
# key_name        = "sridharkrishnamurthy.pem"
# key_file        = "/c/Users/rahulsingh.hada/.aws/rahulsinghhada.pem"
profile         = "2auth"
use_name_prefix = true
use_num_suffix  = true
exec_script     = "./attach_ebs.sh"


# Vars that need to be updated per instance group
create_sg       = true
subnet_suffix   = "sn-4216"
subnet_id       = "subnet-4d614216"
private_ips     = ["10.234.4.202"]
ami             = "ami-0ddc70e50205f89b6"
# instance_name   = "ci-m01-stg-pivot"
instance_name   = "ci-m01-stg"
instance_type   = "m5ad.xlarge"
# hostnames       = ["ci-m01-stg-pivot"]
hostnames       = ["ci-m01-stg"]
sg_name         = "ci-servers-tf"
sg_description  = "CI Jenkins Servers Security Group"
ebs_devices     = [
    {
      # u02 - for /opt jenkins
      device_name = "/dev/sdb"
      volume_type = "gp2"
      volume_size = 100
      delete_on_termination = true
    },
    {
      # var - for /opt/backup 
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 120
      delete_on_termination = true
    },
    {
      # var - for swapfile
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 16
      delete_on_termination = true
    },
]
