terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "euc-els-instances-group1"
    }
  }
}
