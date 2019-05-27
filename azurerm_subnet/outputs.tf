output "azurerm_subnet_name" {
  description = "The name of the subnet created"
  value       = "${azurerm_subnet.subnet.name}"
}

output "azurerm_subnet_id" {
  description = "The Azure network subnet id"
  value       = "${azurerm_subnet.subnet.id}"
}
