module "ec2_sgw" {
  source     = "aws-ia/storagegateway/aws//modules/ec2-sgw"
  vpc_id               = var.ec2_sgw_vpc_id
  subnet_id            = var.ec2_sgw_subnet_id
  name                 = var.sgw_name
  availability_zone    = var.ec2_sgw_az
  create_security_group = var.ec2_sgw_create_security_group
  ingress_cidr_block_activation = var.ingress_cidr_block_activation
  
}


module "sgw" {
  source     = "aws-ia/storagegateway/aws//modules/aws-sgw"
  gateway_name                       = var.sgw_name
  gateway_ip_address                 = module.ec2_sgw.private_ip
  join_smb_domain                    = false
  gateway_type                       = "FILE_S3"
  create_vpc_endpoint                = var.create_vpc_endpoint
  gateway_vpc_endpoint               = var.gateway_vpc_endpoint
  create_vpc_endpoint_security_group = var.create_vpc_endpoint_security_group #if false define vpc_endpoint_security_group_id
  vpc_endpoint_security_group_id     = var.vpc_endpoint_security_group_id
  vpc_id                             = var.vpc_endpoint_vpc_id
  vpc_endpoint_subnet_ids            = var.vpc_endpoint_subnet_ids
  gateway_private_ip_address         = module.ec2_sgw.private_ip
}

module "nfs_share" {
  source        = "aws-ia/storagegateway/aws//modules/s3-nfs-share"
  share_name    = var.nfs_share_name
  gateway_arn   = module.sgw.storage_gateway.arn
  bucket_arn    = var.s3_bucket_arn
  role_arn      = var.nfs_share_role_arn
  log_group_arn = var.nfs_share_log_group_arn
  client_list   = var.nfs_share_client_list
}


