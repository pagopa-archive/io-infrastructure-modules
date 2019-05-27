provider "azurerm" {
  version = "~>1.27"
}

terraform {
  backend "azurerm" {}
}
