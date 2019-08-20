# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_route_table" "route_table" {
  count               = "${var.add_route_table ? 1 : 0}"
  name                = "${local.azurerm_route_table_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_route" "route" {
  count               = "${length(var.azurerm_routes)}"
  name                = "${lookup(var.azurerm_routes[count.index], "name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  route_table_name    = "${azurerm_route_table.route_table.name}"
  address_prefix      = "${lookup(var.azurerm_routes[count.index], "address_prefix")}"
  next_hop_type       = "${lookup(var.azurerm_routes[count.index], "next_hop_type")}"
}

resource "azurerm_subnet" "subnet" {
  count                = "${1 - var.set_subnet_delegation}"
  name                 = "${local.azurerm_subnet_name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
  address_prefix       = "${var.azurerm_subnet_address_prefix}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  service_endpoints    = "${var.azurerm_subnet_service_endpoints}"
}

resource "azurerm_subnet" "subnet_delegation" {
  count                = "${var.set_subnet_delegation}"
  name                 = "${local.azurerm_subnet_name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
  address_prefix       = "${var.azurerm_subnet_address_prefix}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  service_endpoints    = "${var.azurerm_subnet_service_endpoints}"

  delegation {
    name = "delegation"

    service_delegation {
      name    = "${var.azurerm_subnet_delegation_name}"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  count          = "${var.add_route_table * (1 - var.set_subnet_delegation)}"
  subnet_id      = "${azurerm_subnet.subnet.id}"
  route_table_id = "${azurerm_route_table.route_table.id}"
}

resource "azurerm_subnet_route_table_association" "route_table_association_delegation" {
  count          = "${var.add_route_table * var.set_subnet_delegation}"
  subnet_id      = "${azurerm_subnet.subnet_delegation.id}"
  route_table_id = "${azurerm_route_table.route_table.id}"
}

resource "azurerm_network_security_group" "security_group" {
  count               = "${var.add_security_group}"
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

resource "azurerm_subnet_network_security_group_association" "security_group_association" {
  count                     = "${var.add_security_group * (1 - var.set_subnet_delegation)}"
  subnet_id                 = "${azurerm_subnet.subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"
}

resource "azurerm_subnet_network_security_group_association" "security_group_association_delegation" {
  count                     = "${var.add_security_group * var.set_subnet_delegation}"
  subnet_id                 = "${azurerm_subnet.subnet_delegation.id}"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"
}
