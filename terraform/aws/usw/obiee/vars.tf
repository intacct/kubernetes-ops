variable "region" {
  default = "us-west-2"
}

variable "vpc" {
  default = "vpc-48c2bd2e"
}

variable "subnet" {
  default = "subnet-01b304d44d86e2230"
}

# variable "security-group" {
#   default = "sg-0e714cfcce12199b8"
# }

# CentOS 7 x86_64 HVM image
variable "ami" {
  default = "ami-01ed306a12b7d1c96"
}

variable "keyname" {
  default = "sridhar.krishnamurthy"
}

variable "instance-tags" {
  type    = list
  default = ["usw-obi02", "usw-obi03"]
}

variable "ips" {
  default =  {
    "0" = "10.234.9.12"
    "1" = "10.234.9.13"
  }  
}

variable "instance-type" {
  default = "m5.xlarge"
}