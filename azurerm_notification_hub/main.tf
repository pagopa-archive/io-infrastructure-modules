# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_notification_hub_namespace" "notification_hub_ns" {
  name                = "${local.azurerm_notification_hub_namespace_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  namespace_type      = "NotificationHub"

  sku {
    name = "${var.azurerm_notification_hub_namespace_sku_name}"
  }
}

resource "azurerm_notification_hub" "notification_hub" {
  name                = "${local.azurerm_notification_hub_name}"
  namespace_name      = "${azurerm_notification_hub_namespace.notification_hub_ns.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"
}
