terraform {
  backend "remote" {
    # hostname = "app.terraform.io"
    organization = "intacct"

    workspaces {
      name = "usw-oracle-instances-ci-gdb-group1"
    }
  }
}
