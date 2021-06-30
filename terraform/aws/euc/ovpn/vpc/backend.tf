terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "tf-euc-ovpn-vpc"
    }
  }
}
