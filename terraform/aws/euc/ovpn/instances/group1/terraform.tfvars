# Vars that don't need to be touched for euc
region          = "eu-central-1"
name_prefix     = "euc"
vpc_id          = "vpc-4b8def20" // frankfurt
key_name        = "sridhar.krishnamurthy-frankfurt"
key_file        = "~/.aws/sridharkrishnamurthy-frankfurt.pem"
profile         = "2auth"
use_name_prefix = true
use_num_suffix  = true
exec_script     = "./attach_ebs.sh"

# Vars that need to be updated per instance group
subnet_id       = "subnet-0fa7e0f6001141ad8" // ovpn
subnet_suffix   = "sn-1ad8"
create_sg       = true
sg_name         = "ovpn-tf"
sg_description  = "OVPN Security Group"  
ami             = "ami-0e337c7f9752d9d34" // Centos 8
instance_name   = "ovpn"
instance_type   = "m5.xlarge"
hostnames       = ["ovpn01"]
private_ips     = ["10.235.13.10"]
ebs_devices     = []