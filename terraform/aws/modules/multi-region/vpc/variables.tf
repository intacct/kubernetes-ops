variable "vpc_id" {
    description = "Id of the existing VPC where the subnet needs to be created"
    type = string
}

variable "create_subnet" {
  description = "Controls if subnet should be created"
  type        = bool
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of SubnetIDs if var.create_subnet is set to false"
  type = list
  default = []
}

variable "subnet_suffix" {
  description = "Suffix to append to subnets name"
  type        = string
  default     = ""
}

# Applicable only if var.create_subnet = true
variable "subnets" {
  description = "A list of subnets CIDR to be created inside the VPC"
  type        = list(string)
  default     = []
}

# Not supported right now
variable "create_subnet_group" {
  description = "Controls if subnet group should be created"
  type        = bool
  default     = false
}

# Applicable only if var.create_subnet = true
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "tags "
  type        = map(string)
  default     = {}
}

variable "subnet_tags" {
  description = "Additional tags for the subnets"
  type        = map(string)
  default     = {}
}

variable "subnet_group_tags" {
  description = "Additional tags for the subnet group"
  type        = map(string)
  default     = {}
}

variable "acl_tags" {
  description = "Additional tags for the subnets network ACL"
  type        = map(string)
  default     = {}
}


variable "create_default_network_acl" {
  description = "Whether to use default network ACL for subnets"
  type        = bool
  default     = false
}

variable "create_network_acl" {
  description = "Whether to use network ACL (not default) and custom rules for  subnets"
  type        = bool
  default     = false
}

variable "inbound_acl_rules" {
  description = "subnets inbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "outbound_acl_rules" {
  description = "subnets outbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}