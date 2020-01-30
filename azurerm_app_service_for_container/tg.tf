provider "azurerm" {
  version = "~>1.41"
}

terraform {
  backend "azurerm" {}
}
