# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${var.azurerm_resource_group_name}"
}

resource "azurerm_public_ip" "public_ip" {
  name                  = "${local.azurerm_public_ip_name}"
  location              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  allocation_method     = "${var.azurerm_public_ip_allocation_method}"
  sku                   = "${var.azurerm_public_ip_sku}"

  tags = {
    environment = "${var.environment}"
  }
}
