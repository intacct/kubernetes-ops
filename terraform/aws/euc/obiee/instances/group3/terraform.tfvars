# Vars that need to be localized
region          = "eu-central-1"
name_prefix     = "euc"
vpc_id          = "vpc-4b8def20" // frankfurt
subnet_suffix   = "sn-26ad"
subnet_id       = "subnet-04a4a066da20f26ad" // obiee
private_ips     = ["10.235.10.17"]
key_name        = "sridhar.krishnamurthy-frankfurt"
key_file        = "/Users/skrishnamurthy/.aws/sridharkrishnamurthy-frankfurt.pem"
ami             = "ami-0e337c7f9752d9d34" // Centos 8
sg_id           = ["sg-06f09b906e2acda88"] //euc_obi

profile         = "2auth"
//instance_count  = 2
use_name_prefix = true
instance_name   = "obi"
use_num_suffix  = true
instance_type   = "m5.xlarge"
hostnames       = ["obi08"]
exec_script     = "./attach_ebs.sh"
sg_name         = "euc-obi"
create_sg       = false