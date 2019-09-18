output "web_test_id" {
  description = "Id of the newly created web test"
  value       = "${azurerm_application_insights_web_test.web_test.*.id}"
}
