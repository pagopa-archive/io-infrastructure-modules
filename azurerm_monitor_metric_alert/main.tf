# The module configure an alert based on a metric

# Existing infrastructure
data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_monitor_action_group" "action_group" {
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  name                = "${local.azurerm_monitor_action_group_name}"
}

# New infrastructure
resource "azurerm_monitor_metric_alert" "resource_to_monitor" {
  count               = "${length(var.alerts)}"
  name                = "${lookup(var.alerts[count.index], "azurerm_monitor_metric_alert_name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  scopes              = ["${lookup(var.alerts[count.index], "azurerm_monitor_metric_alert_scopes")}"]
  description         = "${lookup(var.alerts[count.index], "azurerm_monitor_metric_alert_description")}"

  criteria {
    aggregation      = "${lookup(var.alerts[count.index], "azurerm_monitor_metric_alert_criteria_aggregation")}"
    metric_name      = "${lookup(var.alerts[count.index], "azurerm_monitor_metric_alert_criteria_metric_name")}"
    metric_namespace = "${lookup(var.alerts[count.index], "azurerm_monitor_metric_alert_criteria_metric_namespace")}"
    operator         = "${lookup(var.alerts[count.index], "azurerm_monitor_metric_alert_criteria_operator")}"
    threshold        = "${lookup(var.alerts[count.index], "azurerm_monitor_metric_alert_criteria_treshold")}"
  }

  action {
    action_group_id = "${data.azurerm_monitor_action_group.action_group.id}"
  }
}
