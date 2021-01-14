# Vars that need to be localized
region          = "eu-central-1"
name_prefix     = "euc"
vpc_id          = "vpc-4b8def20" // frankfurt
subnet_suffix   = "sn-26ad"
subnet_id       = "subnet-04a4a066da20f26ad" // obiee
private_ips     = ["10.235.10.16"]
key_name        = "sridhar.krishnamurthy-frankfurt"
key_file        = "/Users/skrishnamurthy/.aws/sridharkrishnamurthy-frankfurt.pem"
ami             = "ami-08b6d44b4f6f7b279" // Centos 7
sg_id           = ["sg-06f09b906e2acda88"] //euc_obi

profile         = "2auth"
//instance_count  = 2
use_name_prefix = true
instance_name   = "obi"
use_num_suffix  = true
instance_type   = "m5.2xlarge"
hostnames       = ["obi07"]
exec_script     = "./attach_ebs.sh"
sg_name         = "euc-obi"
create_sg       = false