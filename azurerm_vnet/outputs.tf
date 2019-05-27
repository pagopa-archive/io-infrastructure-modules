output "azurerm_virtual_network_id" {
  description = "The Azure virtual network id"
  value       = "${azurerm_virtual_network.vnet.id}"
}
