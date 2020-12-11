terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "euc-els-vpc"
    }
  }
}
