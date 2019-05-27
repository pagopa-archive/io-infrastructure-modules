provider "azurerm" {
  version = "~>1.29"
}

terraform {
  backend "azurerm" {}
}
