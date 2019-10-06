output "azurerm_subnet_name" {
  description = "The name of the subnet created"
  value       = "${local.azurerm_subnet_name}"
}

output "azurerm_subnet_id" { 
  description = "The id of the subnet created"
  value       = "${azurerm_subnet.subnet.*.id}"
}
