provider "azurerm" {
  version = "~>1.34"
}

terraform {
  backend "azurerm" {}
}
