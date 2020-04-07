# Europe (Frankfurt) region
variable "region" {
  default = "eu-central-1"
}

# frankfurt vpc
variable "vpc" {
  default = "vpc-4b8def20"
}

variable "subnet" {
  default = "10.235.9.0/24"
}

# CentOS 7 x86_64 HVM image
variable "ami" {
  default = "ami-337be65c"
}

variable "keyname" {
  default = "sridhar.krishnamurthy-frankfurt"
}

variable "instance_tags" {
  type    = list
  default = ["euc-jgl01", "euc-jgl02"]
}

variable "ips" {
  default =  {
    "0" = "10.235.9.10"
    "1" = "10.235.9.11"
  }  
}

variable "instance_type" {
  default = "t2.xlarge"
}