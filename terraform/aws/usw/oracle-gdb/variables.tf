variable "region" {
    type    = string
    default = "us-west-2"
}

variable "auth_profile" {
    description = "Profile to be used for AWS authentication from ~/.aws/credentials file"
    type    = string
    default = "2auth"
}

variable "instance_type" {
    default = "m5a.4xlarge"
}

variable "ami" {
    # CentOS 7 AMI provided by CentOS "ami-a042f4d8" could not be used 
    # as it does not have ENA enabled
    # Elastic Network Adapter (ENA) is required for the 'm5a.4xlarge' instance type. Ensure that you are using an AMI that is enabled for ENA.
    default = "ami-01ed306a12b7d1c96"
}

variable "vpc" {
    default = "vpc-48c2bd2e"
}

variable "subnet" {
    default = "subnet-ec035db7"
}

variable "sg_name" {
    default = "oracle-tf"
}

variable "nacl_name" {
    default = "oracle-tf"
}

variable "ips" {
    type    = list
    default = ["10.234.2.12"]
}

variable "hostnames" {
    type    = list
    default = ["usw-gdb01"]
} 

variable "key_name" {
    default = "sridhar.krishnamurthy"
}

variable "key_file" {
    default = "~/.aws/sridharkrishnamurthy.pem"
}