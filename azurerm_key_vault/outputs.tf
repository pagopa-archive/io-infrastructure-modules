output "azurerm_resource_group" {
  description = "The name of the resource group where the keyvault has been created."
  value       = "${data.azurerm_resource_group.rg.name}"
}

output "azurerm_key_vault_name" {
  description = "The name of the keyvault created."
  value       = "${azurerm_key_vault.key_vault.name}"
}
