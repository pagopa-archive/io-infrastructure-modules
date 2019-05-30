# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "${local.azurerm_cosmosdb_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql_database" {
  name                = "${local.azurerm_cosmosdb_documentdb_name}"
  resource_group_name = "${data.azurerm_cosmosdb_account.cosmosdb_account.resource_group_name}"
  account_name        = "${data.azurerm_cosmosdb_account.cosmosdb_account.name}"
}
