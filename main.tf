# The module configures basic monitoring configuration

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}


resource "azurerm_monitor_action_group" "monitor_action_group" {
  name                = "${var.monitoring_ag_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  short_name          = "${var.monitoring_ag_short_name}"

  email_receiver {
    name            = "${var.email_receiver_unique_name}"
    email_address   = "${var.email_receiver_email}"
  }
}
