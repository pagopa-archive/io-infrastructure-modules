output "application_insights_id" {
  value       = "${azurerm_application_insights.azurerm_application_insights.*.id}"
  description = "The ID of the Application Insights component."
}

output "application_insights_app_id" {
  value       = "${azurerm_application_insights.azurerm_application_insights.*.app_id}"
  description = "The App ID associated with this Application Insights component."
}

output "application_insights_instrumentation_key" {
  value       = "${azurerm_application_insights.azurerm_application_insights.*.instrumentation_key}"
  description = "The Instrumentation Key for this Application Insights component."
}
