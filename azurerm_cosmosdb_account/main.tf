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
  virtual_network_rule              = {
    id = "${element(data.azurerm_subnet.functions.*.id, 3)}"
  }
}

# Save CosmosDB URI and keys as secrets in the Azure keyvault,
# in order to be used by the functions

# Admin functions

resource "azurerm_key_vault_secret" "fn2adminCosmosdbUri" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "fn2adminCosmosdbUri"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.endpoint}"
}

resource "azurerm_key_vault_secret" "fn2adminCosmosdbKey" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "fn2adminCosmosdbKey"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.primary_master_key}"
}

# App functions

resource "azurerm_key_vault_secret" "fn2appCosmosdbUri" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "fn2appCosmosdbUri"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.endpoint}"
}

resource "azurerm_key_vault_secret" "fn2aappCosmosdbKey" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "fn2appCosmosdbKey"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.primary_master_key}"
}

# Services functions

resource "azurerm_key_vault_secret" "fn2servicesCosmosdbUri" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "fn2servicesCosmosdbUri"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.endpoint}"
}

resource "azurerm_key_vault_secret" "fn2servicesCosmosdbKey" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "fn2servicesCosmosdbKey"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.primary_master_key}"
}

# Public functions

resource "azurerm_key_vault_secret" "fn2publicCosmosdbUri" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "fn2publicCosmosdbUri"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.endpoint}"
}

resource "azurerm_key_vault_secret" "fn2publicCosmosdbKey" {
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
  name         = "fn2publicCosmosdbKey"
  value        = "${azurerm_cosmosdb_account.cosmosdb_account.primary_master_key}"
}
