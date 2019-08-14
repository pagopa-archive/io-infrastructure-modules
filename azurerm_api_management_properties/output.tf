output "named_values" {
  description = "The API Management Named Values"
  value       = "${azurerm_api_management_property.named_values.*.name}"
}

output "secret_named_values" {
  description = "The API Management Secret Named Values (secrets are hidden)"
  value       = "${azurerm_api_management_property.named_values.*.name}"
}
