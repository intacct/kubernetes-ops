terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "tf-euc-ovpn-instances-group1"
    }
  }
}
