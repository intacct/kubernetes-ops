# Oregon region
variable "region" {
  default = "us-west-2"
}

# eng-oregon vpc
variable "vpc" {
  default = "vpc-48c2bd2e"
}

variable "subnet" {
  default = "10.234.11.0/24"
}

# CentOS 7 x86_64 HVM image
variable "ami" {
  default = "ami-01ed306a12b7d1c96"
}

variable "keyname" {
  default = "sridhar.krishnamurthy"
}

variable "instance_tags" {
  type    = list
  default = ["usw-jgl01", "usw-jgl02"]
}

variable "ips" {
  default =  {
    "0" = "10.234.11.10"
    "1" = "10.234.11.11"
  }  
}

