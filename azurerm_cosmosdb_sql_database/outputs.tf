output "azurerm_cosmosdb_documentdb_name" {
  description = "Cosmos DB database name."
  value       = "${local.azurerm_cosmosdb_documentdb_name}"
}

output "azurerm_cosmosdb_documentdb_id" {
  description = "Cosmos DB database id."
  value       = "${azurerm_cosmosdb_sql_database.cosmosdb_sql_database.id}"
}
