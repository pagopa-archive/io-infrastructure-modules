# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${local.azurerm_public_ip_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  allocation_method   = "Static"

  tags = {
    environment = "${var.environment}"
  }
}
