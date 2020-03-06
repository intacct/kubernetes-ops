variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  default = "10.234.50.0/24"
}

variable "subnet_cidr" {
  default = "10.234.50.0/27"
}

