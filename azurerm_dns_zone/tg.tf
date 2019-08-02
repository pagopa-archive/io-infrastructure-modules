provider "azurerm" {
  version = "~>1.32"
}

terraform {
  backend "azurerm" {}
}
