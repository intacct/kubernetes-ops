# Vars that need to be localized
region          = "us-west-2"
name_prefix     = "usw"
vpc_id          = "vpc-48c2bd2e"
subnet_suffix   = "sn-af8e"
subnet_id       = "subnet-06ff1225acd53af8e"
private_ips     = ["10.234.12.10","10.234.12.11"]
key_name        = "sridhar.krishnamurthy"
key_file        = "/Users/skrishnamurthy/.aws/sridharkrishnamurthy.pem"
ami             = "ami-0157b1e4eefd91fd7"

profile         = "2auth"
instance_count  = 2
use_name_prefix = true
instance_name   = "els"
use_num_suffix  = true
instance_type   = "t3a.large"
hostnames       = ["els01","els02"]
exec_script     = "./attach_ebs.sh"
sg_name         = "els-tf"