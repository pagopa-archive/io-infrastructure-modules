output "name" {
  description = "The function app name"
  value       = "${local.azurerm_functionapp_name}"
}

output "id" {
  description = "The function app id"
  value       = "${module.azurerm_function_app_site.id}"
}
