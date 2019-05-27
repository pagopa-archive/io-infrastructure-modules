# Existing infrastructure

data "azurerm_virtual_network" "x_vnet" {
  name                = "${local.azurerm_virtual_network_x_vnet_name}"
  resource_group_name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "y_vnet" {
  name                = "${local.azurerm_virtual_network_y_vnet_name}"
  resource_group_name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_virtual_network_peering" "peering_x_y" {
  name                         = "${local.azurerm_virtual_network_peering_peering_x_y_name}"
  resource_group_name          = "${local.azurerm_resource_group_name}"
  virtual_network_name         = "${data.azurerm_virtual_network.x_vnet.name}"
  remote_virtual_network_id    = "${data.azurerm_virtual_network.y_vnet.id}"
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peering_y_x" {
  name                         = "${local.azurerm_virtual_network_peering_peering_y_x_name}"
  resource_group_name          = "${local.azurerm_resource_group_name}"
  virtual_network_name         = "${data.azurerm_virtual_network.y_vnet.name}"
  remote_virtual_network_id    = "${data.azurerm_virtual_network.x_vnet.id}"
  allow_virtual_network_access = true
}
