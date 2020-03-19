# Oregon region
variable "region" {
  default = "us-west-2" 
}

# eng-oregon vpc
variable "vpc" {
  default = "vpc-48c2bd2e"
}

variable "subnet" {
  default = "10.234.15.0/28"
}

# CentOS 7 x86_64 HVM image
variable "ami" {
  default = "ami-01ed306a12b7d1c96"
}
