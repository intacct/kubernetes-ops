# _provider.tf
provider "aws" {
    alias = "us-west-2"
    region = "us-west-2" 
}

provider "aws" {
    alias  = "eu-central-1"
    region = "eu-central-1"
}