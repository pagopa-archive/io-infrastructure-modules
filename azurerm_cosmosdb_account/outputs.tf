output "azurerm_cosmosdb_account_name" {
  description = "The name of the CosmosDB created."
  value       = "${azurerm_cosmosdb_account.cosmosdb_account.name}"
}

output "azurerm_cosmosdb_account_endpoint" {
  description = "The endpoint used to connect to the CosmosDB account."
  value       = "${azurerm_cosmosdb_account.cosmosdb_account.endpoint}"
}

output "azurerm_cosmosdb_account_write_endpoints" {
  description = "A list of write endpoints available for this CosmosDB account."
  value       = "${azurerm_cosmosdb_account.cosmosdb_account.write_endpoints}"
}

output "azurerm_cosmosdb_account_read_endpoints" {
  description = "A list of read endpoints available for this CosmosDB account."
  value       = "${azurerm_cosmosdb_account.cosmosdb_account.read_endpoints}"
}

output "azurerm_cosmosdb_account_geo_master_location" {
  description = "The master location where data are saved."
  value       = "${var.azurerm_cosmosdb_account_geo_location_master}"
}

output "azurerm_cosmosdb_account_geo_slave_location" {
  description = "The slave location where data are saved."
  value       = "${var.azurerm_cosmosdb_account_geo_location_slave}"
}
