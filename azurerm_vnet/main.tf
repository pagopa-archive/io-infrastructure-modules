# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  address_space       = ["${var.azurerm_virtual_network_address_space}"]
}
