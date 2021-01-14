terraform {
  backend "remote" {
    # hostname = "app.terraform.io"
    organization = "intacct"

    workspaces {
      name = "euc-obiee-instances-group1"
    }
  }
}
