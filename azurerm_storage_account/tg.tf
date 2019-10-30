provider "azurerm" {
  version = "~>1.36"
}

provider "azuread" {
  version = "~>0.2"
}

terraform {
  backend "azurerm" {}
}
