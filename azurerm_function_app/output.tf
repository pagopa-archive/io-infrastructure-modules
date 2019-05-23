output "name" {
  description = "The function app name"
  value       = "${azurerm_function_app.azurerm_function_app.name}"
}

output "id" {
  description = "The function app id"
  value       = "${azurerm_function_app.azurerm_function_app.id}"
}
