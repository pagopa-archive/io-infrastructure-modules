# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_storage_account" "sa_backup" {
  name                = "${local.azurerm_storage_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "subnet" {
  name                 = "${local.azurerm_subnet_name}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_redis_cache" "redis_cache" {
  name                      = "${local.azurerm_redis_cache_name}"
  location                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name       = "${data.azurerm_resource_group.rg.name}"
  capacity                  = "${var.azurerm_redis_cache_capacity}"
  shard_count               = "${var.azurerm_redis_cache_shard_count}"
  enable_non_ssl_port       = "${var.azurerm_redis_cache_enable_non_ssl_port}"
  subnet_id                 = "${data.azurerm_subnet.subnet.id}"
  private_static_ip_address = "${var.azurerm_redis_cache_private_static_ip_address}"
  family                    = "${var.azurerm_redis_cache_family}"
  sku_name                  = "${var.azurerm_redis_cache_sku_name}"

  redis_configuration       = {
    rdb_backup_frequency          = "${var.azurerm_redis_cache_redis_configuration_rdb_backup_frequency}"
    rdb_backup_max_snapshot_count = "${var.azurerm_redis_cache_redis_configuration_rdb_backup_max_snapshot_count}"
    rdb_backup_enabled            = "${var.azurerm_redis_cache_redis_configuration_rdb_backup_enabled}"
    rdb_storage_connection_string = "${data.azurerm_storage_account.sa_backup.primary_connection_string}"
  }

  tags {
    environment = "${var.environment}"
  }
  # NOTE: There's a bug in the Redis API where the original storage connection string isn't being returned,
  # which is being tracked here [https://github.com/Azure/azure-rest-api-specs/issues/3037].
  # In the interim we use the ignore_changes attribute to ignore changes to this field.
  lifecycle {
    ignore_changes = ["redis_configuration.0.rdb_storage_connection_string"]
  }
}
