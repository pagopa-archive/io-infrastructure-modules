provider "azurerm" {
  version = "~>1.29"
}

provider "azuread" {
  version = "~>0.2"
}

terraform {
  backend "azurerm" {}
}
