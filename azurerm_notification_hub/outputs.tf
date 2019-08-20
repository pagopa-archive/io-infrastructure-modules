output "azurerm_notification_hub_namespace_name" {
  description = "The name of the notification hub namespace."
  value       = "${local.azurerm_notification_hub_namespace_name}"
}

output "azurerm_notification_hub_name" {
  description = "The name of the notification hub."
  value       = "${local.azurerm_notification_hub_name}"
}

output "azurerm_notification_hub_id" {
  value = "${azurerm_notification_hub.notification_hub.id}"
}
