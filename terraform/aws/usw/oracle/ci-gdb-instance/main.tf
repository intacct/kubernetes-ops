provider "aws" {
    region = "us-west-2"
    profile = "2auth"
}


module "deploy_ci_instance" {
    source          = "../../../modules/multi-region/oracle-gdb"

    create_nacl     = false
    create_security_group = false
    create_instance = false
    instance_type   = "m5a.4xlarge"
    # ami             = "ami-0157b1e4eefd91fd7" // Cenos 8 x86_64
    ami             = "ami-0a248ce88bcc7bd23" // Centos 7 x86_64
    vpc             = "vpc-48c2bd2e" 
    subnet          = "subnet-ec035db7"
    sg_name         = "oracle-tf"
    security_group_ids = ["sg-0d687d1e57b806f8e"]
    # nacl_name       = var.nacl_name
    ips             = ["10.234.2.14"]
    hostnames       = ["usw-ci-gdb01"]
    u01_size        = 100
    u02_size        = 200
    u03_size        = 500
    var_size        = 10
    mount_script    = "../../../modules/multi-region/oracle-gdb/files/attach_ebs.sh"
    key_name        = "sridhar.krishnamurthy"
    key_file        = "~/.aws/sridharkrishnamurthy.pem"
}

