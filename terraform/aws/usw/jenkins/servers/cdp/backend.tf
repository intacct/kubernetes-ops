terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "usw-jenkins-servers-cdp"
    }
  }
}
