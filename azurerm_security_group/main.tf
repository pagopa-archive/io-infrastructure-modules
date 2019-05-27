provider "azurerm" {
  version = "~>1.24"
}

provider "azuread" {
  version = "~>0.2"
}

terraform {
  backend "azurerm" {}
}

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_network_security_group" "security_group" {
  name                = "${local.azurerm_network_security_group_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "security_rule" {
  count                       = "${length(var.azurerm_network_security_rules)}"
  name                        = "${lookup(var.azurerm_network_security_rules[count.index], "name")}"
  priority                    = "${count.index + 1000}"
  direction                   = "${lookup(var.azurerm_network_security_rules[count.index], "direction")}"
  access                      = "${lookup(var.azurerm_network_security_rules[count.index], "access")}"
  protocol                    = "${lookup(var.azurerm_network_security_rules[count.index], "protocol")}"
  source_port_range           = "${lookup(var.azurerm_network_security_rules[count.index], "source_port_range")}"
  destination_port_range      = "${lookup(var.azurerm_network_security_rules[count.index], "destination_port_range")}"
  source_address_prefix       = "${lookup(var.azurerm_network_security_rules[count.index], "source_address_prefix")}"
  destination_address_prefix  = "${lookup(var.azurerm_network_security_rules[count.index], "destination_address_prefix")}"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.security_group.name}"
}
