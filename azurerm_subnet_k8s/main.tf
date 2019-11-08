# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure
resource "azurerm_subnet" "subnet" {
  name                      = "${local.azurerm_subnet_name}"
  resource_group_name       = "${data.azurerm_resource_group.rg.name}"
  address_prefix            = "${var.azurerm_subnet_address_prefix}"
  virtual_network_name      = "${data.azurerm_virtual_network.vnet.name}"
  service_endpoints         = "${var.azurerm_subnet_service_endpoints}"

  lifecycle {
    ignore_changes = ["route_table_id"]
  }
}





