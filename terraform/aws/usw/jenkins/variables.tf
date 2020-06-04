variable "auth_profile" {
    default = "2auth"
}

# Oregon region
variable "region" {
  default = "us-west-2"
}

# eng-oregon vpc
variable "vpc" {
  default = "vpc-48c2bd2e"
}

variable "subnet" {
  default = "subnet-4d614216"
}

# CentOS 7 x86_64 HVM image
variable "ami" {
  default = "ami-01ed306a12b7d1c96"
}

variable "keyname" {
  default = "sridhar.krishnamurthy"
}

variable "hostnames" {
  type    = list
  default = ["usw-ci-n50"]
}

variable "ips" {
  type = list
  default =  ["10.234.4.50"]
}

variable "instance_type" {
  default = "t2.small"
}

variable "key_file" {
    default = "~/.aws/sridharkrishnamurthy.pem"
}
