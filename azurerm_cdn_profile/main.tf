data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

resource "azurerm_cdn_profile" "cdn_profile" {
  name                    = "${local.azurerm_cdn_profile_name}"
  resource_group_name     = "${data.azurerm_resource_group.rg.name}"
  location                = "${data.azurerm_resource_group.rg.location}"

  sku = "${var.azurerm_cdn_profile_sku}"

  tags = {
    environment = "${var.environment}"
  }
}
