provider "aws" {
    region  = var.region
    profile = var.auth_profile
}

module "deploy_oracle_gdb" {
    source          = "../../modules/multi-region/oracle-gdb"

    create_instance = true
    instance_type   = var.instance_type
    ami             = var.ami
    vpc             = var.vpc 
    subnet          = var.subnet
    sg_name         = var.sg_name
    nacl_name       = var.nacl_name
    ips             = var.ips
    hostnames       = var.hostnames
    key_name        = var.key_name
    key_file        = var.key_file
}

