output "azurerm_log_analytics_workspace_name" {
  description = "The name of the logs analytics workspace."
  value       = "${local.azurerm_log_analytics_workspace_name}"
}

output "azurerm_log_analytics_workspace_sku" {
  description = "The SKU of the log analytics workspace."
  value       = "${var.azurerm_log_analytics_workspace_sku}"
}
