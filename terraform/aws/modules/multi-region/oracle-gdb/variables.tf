variable "create_instance" {
    type    = bool
    default = true
}

variable "instance_type" {
    # Refer: https://aws.amazon.com/ec2/instance-types/
    description = "(Optional) AWS instance type.  Defaulted to 8 vCPU and 32GB memory if not set"
    type        = string
    default     = "m5a.4xlarge"
}

variable "ami" {
    type = string
}

variable "vpc" {
    type = string
}

variable "subnet" {
    type = string
}

variable "sg_name" {
    type    = string
    default = ""
}

variable "create_nacl" {
    description = "(Optional).  If set to false, no custom NACL will be created"
    type        = bool
    default     = true
}

variable "nacl_name" {
    type    = string
    default = ""
}

variable "ips" {
    type = list
}

variable "hostnames" {
    description = "A list of hostnames to assign to the instance."
    type        = list
} 

variable "key_name" {
    type = string
}

variable "u01_size" {
    # Holds instllation media / oracle gold image
    description = "(Optional) size of u01 vol.  Defaulted to 100GB if not set"
    type = number
    default = 100
}

variable "u02_size" {
    # Holds archive files ie oracle_d08 and rmab backups
    description = "(Optional) size of u02 vol.  Defaulted to 200GB if not set"
    type = number
    default = 200
}

variable "u03_size" {
    # Holds oracle data
    description = "(Optional) size of u03 vol.  Defaulted to 500GB if not set"
    type = number
    default = 500
}

variable "var_size" {
    # Holds oracle data
    description = "(Optional) size of var vol.  Defaulted to 10GB if not set"
    type = number
    default = 10
}

variable "key_file" {
    description = "name of the pem file to authenticate against instance, including path"
    type = string
}