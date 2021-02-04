provider "aws" {
    region  = var.region
    profile = var.auth_profile
}

module "deploy_oracle_sdb" {
    source          = "../../modules/multi-region/oracle-db"

    create_instance = false
    instance_type   = var.instance_type
    ami             = var.ami
    vpc             = var.vpc 
    subnet          = var.subnet
    sg_id           = var.sg_id
    ips             = var.ips
    hostnames       = var.hostnames
    key_name        = var.key_name
    key_file        = var.key_file
    u01_size        = var.u01_size
    u02_size        = var.u02_size
    u03_size        = var.u03_size
    var_size        = var.var_size
}

