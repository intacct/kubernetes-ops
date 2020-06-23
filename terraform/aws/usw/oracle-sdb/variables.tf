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
    description = "VPC eng-oregon"
    default     = "vpc-48c2bd2e"
}

variable "subnet" {
    description = "subnet oracle"
    default     = "subnet-ec035db7"
}

variable sg_id {
    description = "Security Group ID"
    type        = list
    default     = ["sg-0d687d1e57b806f8e"]

}

variable "ips" {
    type    = list
    default = ["10.234.2.10","10.234.2.13"]
}

variable "hostnames" {
    type    = list
    default = ["usw-db01", "usw-ci-db01"]
} 

variable "key_name" {
    default = "sridhar.krishnamurthy"
}

variable "key_file" {
    default = "~/.aws/sridharkrishnamurthy.pem"
}

variable "u01_size" {
    # Holds instllation media / oracle gold image
    description = "Size of /u01 volume in GB"
    type = number
    default = 100
}

variable "u02_size" {
    # Holds archive files ie oracle_d08 and rmab backups
    description = "Size of /u02 volume in GB"
    type = number
    default = 1000
}

variable "u03_size" {
    # Holds oracle data
    description = "Size of /u03 volume in GB"
    type = number
    default = 1500
}

variable "var_size" {
    # Holds oracle data
    description = "Size of /var volume in GB"
    type = number
    default = 10
}
