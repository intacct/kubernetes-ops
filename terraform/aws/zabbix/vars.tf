# Oregon region
variable "region" {
  default = "us-west-2" 
}

# eng-oregon vpc
variable "vpc" {
  default = "vpc-48c2bd2e"
}

# Use aux subnet for monitoring 10.234.5.0/24
variable "subnet" {
  default = "subnet-6489a23f"
}

# CentOS 7 x86_64 HVM image
variable "ami" {
  default = "ami-01ed306a12b7d1c96"
}
