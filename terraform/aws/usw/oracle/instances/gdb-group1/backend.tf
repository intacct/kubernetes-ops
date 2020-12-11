terraform {
  backend "remote" {
    # hostname = "app.terraform.io"
    organization = "intacct"

    workspaces {
      name = "usw-oracle-instances-gdbgroup1"
    }
  }
}
