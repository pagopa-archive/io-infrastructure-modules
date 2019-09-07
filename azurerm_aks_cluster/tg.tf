provider "azurerm" {
  version = "~>1.33"
}

provider "azuread" {
  version = "~>0.5"
}

terraform {
  backend "azurerm" {}
}
