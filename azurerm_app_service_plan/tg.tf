provider "azurerm" {
  version = "~>1.32.1"
}

terraform {
  backend "azurerm" {}
}
