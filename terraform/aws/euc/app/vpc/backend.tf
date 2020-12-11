terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "euc-app-vpc"
    }
  }
}
