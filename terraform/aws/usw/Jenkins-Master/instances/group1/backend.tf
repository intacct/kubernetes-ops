terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "tf-usw-ci-m01-instances-group1"
    }
  }
}
