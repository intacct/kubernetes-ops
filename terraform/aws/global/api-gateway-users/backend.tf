terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "global-apigatewayusers"
    }
  }
}
