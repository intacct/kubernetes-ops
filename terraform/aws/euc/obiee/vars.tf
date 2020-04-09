# Europe (Frankfurt) region
variable "region" {
  default = "eu-central-1"
}

# frankfurt vpc
variable "vpc" {
  default = "vpc-4b8def20"
}

variable "subnet" {
  default = "10.235.10.0/24"
}

# CentOS 7 x86_64 HVM image
variable "ami" {
  # default = "ami-337be65c"
  default = "ami-04cf43aca3e6f3de3"
}

variable "keyname" {
  default = "sridhar.krishnamurthy-frankfurt"
}

variable "instance_tags" {
  type    = list
  default = ["euc-obi02", "euc-obi03"]
}

variable "ips" {
  default =  {
    "0" = "10.235.10.11"
    "1" = "10.235.10.12"
  }  
}

variable "instance_type" {
  default = "m5.xlarge"
}