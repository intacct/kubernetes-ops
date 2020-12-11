terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "usw-audittrail"
    }
  }
}

