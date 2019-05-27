output "azurerm_resource_group_id" {
  description = "The Azure resource group id"
  value       = "${azurerm_resource_group.rg.id}"
}
