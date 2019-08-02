  # Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "registration_vnets" {
  count               = "${length(local.azurerm_virtual_network_registration_name)}"
  name                = "${local.azurerm_virtual_network_registration_name[count.index]}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_virtual_network" "resolution_vnets" {
  count               = "${length(local.azurerm_virtual_network_resolution_name)}"
  name                = "${local.azurerm_virtual_network_resolution_name[count.index]}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure
resource "azurerm_dns_zone" "dns_zone" {
  name                             = "${local.azurerm_dns_zone_name}"
  resource_group_name              = "${data.azurerm_resource_group.rg.name}"
  zone_type                        = "${var.azurerm_dns_zone_zone_type}"
  registration_virtual_network_ids = ["${data.azurerm_virtual_network.registration_vnets.*.id}"]
  resolution_virtual_network_ids   = ["${data.azurerm_virtual_network.resolution_vnets.*.id}"]

  tags = {
    environment = "${var.environment}"
  }
}
