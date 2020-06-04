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
  type = list
  default = ["ami-01ed306a12b7d1c96","ami-01ed306a12b7d1c96","ami-0115e4834c4a3d983"]
}

variable "ips" {
  type = list
  default = ["10.234.5.14", "10.234.5.15", "10.234.5.16"]
  # default = ["10.234.5.14"]
}

variable "hostnames" {
  type = list
  default = ["usw-zbx-01", "usw-zbx-02", "usw-zbx-03"]
}

variable "key_file" {
    default = "~/.aws/sridharkrishnamurthy.pem"
}