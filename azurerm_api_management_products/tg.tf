provider "azurerm" {
  version = "~>1.32.1"
}

provider "azuread" {
  version = "~>0.5"
}

terraform {
  backend "azurerm" {}
}
