#storage Gateway
variable "ec2_sgw_vpc_id" {
    description = "The VPC ID in which the Storage Gateway security group will be created in"
    type = string
}

variable "ec2_sgw_subnet_id" {
    type        = string
    description = "VPC Subnet ID to launch in the EC2 Instance"
}

variable "sgw_name" {
  type        = string
  description = "Name of the EC2 Storage Gateway instance"
}

variable "ec2_sgw_aws_region" {
    type = string
    description = "Region where the Ec2 storage Gateway instance"
  
}
variable "ec2_sgw_az" {
    type        = string
    description = "Availability zone for the Gateway EC2 Instance"
}

variable "ec2_sgw_create_security_group" {
    type        = bool
    description = "Create a Security Group for the EC2 Storage Gateway. If create_security_group=false, provide a valid security_group_id"
    default     = true
  
}

variable "ingress_cidr_block_activation" {
  type        = string
  description = "The CIDR block to allow ingress port 80 into your File Gateway instance for activation. For multiple CIDR blocks, please separate with comma"
}


#NFS Share
variable "nfs_share_name" {
    description = "Name of the nfs file share"
    type        = string
}

variable "s3_bucket_arn" {
    type = string
    description = "ARn of the S3 bucket to use for nfs storage"
}

variable "nfs_share_role_arn" {
    type = string
    description = "The ARN of the AWS Identity and Access Management (IAM) role that a file gateway assumes when it accesses the underlying storage"
}

variable "nfs_share_log_group_arn" {
    type = string
    description = "Cloudwatch Log Group ARN for audit logs"
}

variable "nfs_share_client_list" {
  type        = list(any)
  sensitive   = true
  description = "The list of clients that are allowed to access the file gateway. The list must contain either valid IP addresses or valid CIDR blocks. Minimum 1 item. Maximum 100 items."
}



variable "create_vpc_endpoint" {
  type        = bool
  description = "Create an interface VPC endpoint for the Storage Gateway"
  default     = false
}

#If create_vpc_endpoint is false
variable "gateway_vpc_endpoint" {
  type        = string
  description = "Existing VPC endpoint address to be used when activating your gateway. This variable value will be ignored if setting create_vpc_endpoint=true."
  default     = null
}

#If create_vpc_endpoint is true
variable "vpc_endpoint_vpc_id" {
  type        = string
  description = "VPC id for creating a VPC endpoint. Must provide a valid value if create_vpc_endpoint=true."
  default     = null
}

variable "create_vpc_endpoint_security_group" {
  type        = bool
  description = "Create a Security Group for the VPC Endpoint for Storage Gateway"
  default     = false
}

variable "vpc_endpoint_security_group_id" {
  type        = string
  description = "Optionally provide an existing Security Group ID to associate with the VPC Endpoint. Must be set if create_vpc_endpoint_security_group=false"
  default     = null
}

variable "vpc_endpoint_subnet_ids" {
  type        = list(string)
  description = "Provide existing subnet IDs to associate with the VPC Endpoint. Must provide a valid values if create_vpc_endpoint=true."
  default     = null
}



