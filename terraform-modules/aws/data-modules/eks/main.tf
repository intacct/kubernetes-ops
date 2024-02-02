variable "s3_bucket" {}
variable "key" {}
variable "region" {}
variable "dynamodb_table" {}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = var.s3_bucket
    key = var.key
    region = var.region
    dynamodb_table = var.dynamodb_table
    
  }
}

output "all_outputs" {
  value = data.terraform_remote_state.eks.outputs
}
