terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "euc-mongo-vpc"
    }
  }
}
