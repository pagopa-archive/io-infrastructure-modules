output "azurerm_public_ip_ip_address" {
  description = "The public IP address allocated."
  value       = "${azurerm_public_ip.public_ip.ip_address}"
}
