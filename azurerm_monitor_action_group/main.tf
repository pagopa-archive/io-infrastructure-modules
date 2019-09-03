# The module configures basic monitoring configuration

# Existing infrastructure
data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure
resource "azurerm_monitor_action_group" "monitor_action_group" {
  name                = "${local.azurerm_monitor_action_group_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  short_name          = "${var.azurerm_monitor_action_group_short_name}"

  email_receiver {
    name            = "${var.azurerm_monitor_action_group_email_receiver_name}"
    email_address   = "${var.azurerm_monitor_action_group_email_receiver_email_address}"
  }
}
