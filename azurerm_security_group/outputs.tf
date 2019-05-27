output "azurerm_network_security_group" {
  description = "The name of the security group created."
  value       = "${azurerm_network_security_group.security_group.name}"
}
