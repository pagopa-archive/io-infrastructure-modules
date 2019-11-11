provider "azurerm" {
  version = "~>1.36"
}

terraform {
  backend "azurerm" {}
}
