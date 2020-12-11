terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "usw-app-instances-group1"
    }
  }
}

