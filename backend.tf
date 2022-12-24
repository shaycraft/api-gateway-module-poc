terraform {
  cloud {
    organization = "mr-gav-meow"

    workspaces {
      name = "api-gateway-module-poc"
    }
  }
}
