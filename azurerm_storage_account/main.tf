# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "vnets" {
  count               = "${length(var.allowed_subnets_suffixes)}"
  name                = "${var.resource_name_prefix}-${var.environment}-vnet-common"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "subnets" {
  count                = "${length(var.allowed_subnets_suffixes)}"
  name                 = "${var.resource_name_prefix}-${var.environment}-subnet-${var.allowed_subnets_suffixes[count.index]}"
  virtual_network_name = "${var.resource_name_prefix}-${var.environment}-vnet-common"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault" "key_vault" {
  count               = "${var.create_keyvault_secret}"
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_storage_account" "storage_account" {
  count                    = "${var.set_firewall}"
  name                     = "${local.azurerm_storage_account_name}"
  resource_group_name      = "${data.azurerm_resource_group.rg.name}"
  location                 = "${var.location}"
  account_tier             = "${var.azurerm_storage_account_account_tier}"
  account_replication_type = "${var.azurerm_storage_account_account_replication_type}"

  network_rules {
    default_action             = "${var.azurerm_storage_account_network_rules_default_action}"
    ip_rules                   = ["${var.azurerm_storage_account_network_rules_allowed_ips}"]
    virtual_network_subnet_ids = ["${data.azurerm_subnet.subnets.*.id}"]
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_account" "storage_account_no_firewall" {
  count                    = "${1 - var.set_firewall}"
  name                     = "${local.azurerm_storage_account_name}"
  resource_group_name      = "${data.azurerm_resource_group.rg.name}"
  location                 = "${var.location}"
  account_tier             = "${var.azurerm_storage_account_account_tier}"
  account_replication_type = "${var.azurerm_storage_account_account_replication_type}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_key_vault_secret" "storage_account_secret" {
  count        = "${(var.create_keyvault_secret == 1) && (var.set_firewall == 1) ? 1 : 0}"
  name         = "fn2-common-sa-${var.storage_account_name}-primary-connection-string"
  value        = "${azurerm_storage_account.storage_account.primary_connection_string}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

resource "azurerm_key_vault_secret" "storage_account_secret_no_firewall" {
  count        = "${(var.create_keyvault_secret == 1) && (var.set_firewall == 0) ? 1 : 0}"
  name         = "fn2-common-sa-${var.storage_account_name}-primary-connection-string"
  value        = "${azurerm_storage_account.storage_account_no_firewall.primary_connection_string}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}
