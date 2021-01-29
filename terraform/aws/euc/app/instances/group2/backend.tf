terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "euc-app-instances-group2"
    }
  }
}
