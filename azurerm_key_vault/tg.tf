provider "azurerm" {
  version = "~>1.33"
}

terraform {
  backend "azurerm" {}
}
