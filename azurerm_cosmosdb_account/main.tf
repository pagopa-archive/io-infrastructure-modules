# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                      = "${local.azurerm_cosmosdb_account_name}"
  location                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name       = "${data.azurerm_resource_group.rg.name}"
  offer_type                = "${var.azurerm_cosmosdb_account_offer_type}"
  kind                      = "${var.azurerm_cosmosdb_account_kind}"

  enable_automatic_failover = true

  consistency_policy        = ["${var.azurerm_cosmosdb_account_consistency_policy}"]

  # TODO: create arbitrary number of geo_locations with terraform 0.12

  geo_location              = ["${var.azurerm_cosmosdb_account_geo_location_master}"]
  geo_location              = ["${var.azurerm_cosmosdb_account_geo_location_slave}"]
}
