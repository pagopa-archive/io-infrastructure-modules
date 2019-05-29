output "azurerm_eventhub_namespace_name" {
  description = "The name of the eventhub namespace created."
  value       = "${local.azurerm_eventhub_namespace_name}"
}

output "azurerm_eventhub_name" {
  description = "The name of the eventhub created."
  value       = "${local.azurerm_eventhub_name}"
}
