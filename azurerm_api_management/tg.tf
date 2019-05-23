
provider "azurerm" {
  version = "~>1.24"
}

provider "azuread" {
  version = "~>0.2"
}

terraform {
  backend "azurerm" {}
}
