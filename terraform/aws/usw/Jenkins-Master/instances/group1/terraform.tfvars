# Vars that don't need to be touched for usw
region          = "us-west-2"
name_prefix     = "usw"
vpc_id          = "vpc-48c2bd2e"
key_name        = "rahulsinghhada.pem"
key_file        = "/c/Users/rahulsingh.hada/.aws/rahulsinghhada.pem"
profile         = "2auth"
use_name_prefix = true
use_num_suffix  = true
exec_script     = "./attach_ebs.sh"


# Vars that need to be updated per instance group
subnet_suffix   = "sn-4216"
subnet_id       = "subnet-4d614216"
sg_description  = "ci"  
private_ips     = ["10.234.4.201"]
ami             = "ami-0155c31ea13d4abd2"
instance_name   = "ci-m01-test"
instance_type   = "r5.xlarge"
hostnames       = ["ci-m01-test"]
sg_name         = "ci-app-servers"
ebs_devices     = []
