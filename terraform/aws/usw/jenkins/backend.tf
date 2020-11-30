terraform {
  backend "remote" {
    # hostname = "app.terraform.io"
    organization = "intacct"


    workspaces {
      name = "tf-usw-jenkins"
    }
  }
}
