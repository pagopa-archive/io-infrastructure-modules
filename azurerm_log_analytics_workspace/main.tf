# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.azurerm_log_analytics_workspace_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  sku                 = "${var.azurerm_log_analytics_workspace_sku}"

  tags {
    environment = "${var.environment}"
  }
}
