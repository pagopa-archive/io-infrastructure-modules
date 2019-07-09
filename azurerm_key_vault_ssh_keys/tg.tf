provider "azurerm" {
  version = "~>1.29"
}

provider "null" {
    version = "~> 2.1.2"
}

terraform {
  backend "azurerm" {}
}
