terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "tf-usw-els-instances-group1"
    }
  }
}
