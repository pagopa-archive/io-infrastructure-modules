output "properties" {
  description = "The API Management properties"
  value       = "${azurerm_api_management_property.properties.*.name}"
}
