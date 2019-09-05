output "azurerm_monitor_metric_alert_id" {
   description = "Id of the newly created alert"
   value       = "${azurerm_monitor_metric_alert.resource_to_monitor.*.id}"
}
