# Vars that don't need to be touched for usw
region          = "us-west-2"
name_prefix     = "usw"
vpc_id          = "vpc-48c2bd2e"
key_name        = "sridhar.krishnamurthy"
key_file        = "/Users/skrishnamurthy/.aws/sridharkrishnamurthy.pem"
profile         = "2auth"
use_name_prefix = true
use_num_suffix  = true
exec_script     = "./attach_ebs.sh"


# Vars that need to be updated per instance group
subnet_suffix   = "sn-2813"
subnet_id       = "subnet-04d91dcebe5f42813"
sg_description  = "OVPN Security Group"  
private_ips     = ["10.234.13.10"]
ami             = "ami-0ddc70e50205f89b6"
instance_name   = "ovpn"
instance_type   = "m5.xlarge"
hostnames       = ["ovpn01"]
sg_name         = "ovpn-tf"
ebs_devices     = []
