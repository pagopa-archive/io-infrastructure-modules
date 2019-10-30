# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_subnet" "functions" {
  count                = "${length(var.allowed_subnets_suffix)}"
  name                 = "${var.resource_name_prefix}-${var.environment}-subnet-${var.allowed_subnets_suffix[count.index]}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
  virtual_network_name = "${local.azurerm_virtual_network_name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                              = "${local.azurerm_cosmosdb_account_name}"
  location                          = "${data.azurerm_resource_group.rg.location}"
  resource_group_name               = "${data.azurerm_resource_group.rg.name}"
  offer_type                        = "${var.azurerm_cosmosdb_account_offer_type}"
  kind                              = "${var.azurerm_cosmosdb_account_kind}"
  enable_automatic_failover         = true
  consistency_policy                = ["${var.azurerm_cosmosdb_account_consistency_policy}"]

  # Replica settings
  # TODO: create arbitrary number of geo_locations with terraform 0.12

  geo_location                      = {
    prefix            = "${local.azurerm_cosmosdb_account_name}-master"
    location          = "westeurope"
    failover_priority = 0
  }
  geo_location                      = {
    prefix            = "${local.azurerm_cosmosdb_account_name}-slave"
    location          = "northeurope"
    failover_priority = 1
  }

  # Firewall settings

  is_virtual_network_filter_enabled = true
  virtual_network_rule              = {
    id = "${element(data.azurerm_subnet.functions.*.id, 0)}"
  }
  virtual_network_rule              = {
    id = "${element(data.azurerm_subnet.functions.*.id, 1)}"
  }
  virtual_network_rule              = {
    id = "${element(data.azurerm_subnet.functions.*.id, 2)}"
  }
}

# Save CosmosDB URI and keys as secrets in the Azure keyvault,
# in order to be used by the functions

# Admin functions

resource "azurerm_key_vault_secret" "f2nadminCosmosdbUri" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "f2nadminCosmosdbUri"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.endpoint}"
}

resource "azurerm_key_vault_secret" "f2nadminCosmosdbKey" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "f2nadminCosmosdbKey"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.primary_master_key}"
}

# App functions

resource "azurerm_key_vault_secret" "f2nappCosmosdbUri" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "f2nappCosmosdbUri"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.endpoint}"
}

resource "azurerm_key_vault_secret" "f2naappCosmosdbKey" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "f2nappCosmosdbKey"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.primary_master_key}"
}

# Services functions

resource "azurerm_key_vault_secret" "f2nservicesCosmosdbUri" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "f2nservicesCosmosdbUri"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.endpoint}"
}

resource "azurerm_key_vault_secret" "f2nservicesCosmosdbKey" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "f2nservicesCosmosdbKey"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.primary_master_key}"
}
