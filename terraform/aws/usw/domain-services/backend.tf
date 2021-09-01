terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "usw-domain_services"
    }
  }
}

