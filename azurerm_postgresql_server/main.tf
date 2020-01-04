data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_subnet" "subnet" {
  count                = "${var.azurerm_postgresql_subnet_suffix != "" ? 1 : 0}"

  name                 = "${var.resource_name_prefix}-${var.environment}-subnet-${var.azurerm_postgresql_subnet_suffix}"
  virtual_network_name = "${var.resource_name_prefix}-${var.environment}-vnet-common"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# Generate random password
resource "random_string" "postgresql_administrator_login_password" {
  length           = 20
  special          = true
  override_special = "!@#$&*()-_=+[]{}<>:?"
}

# Save password in vault
resource "azurerm_key_vault_secret" "postgresql_key_vault_secret" {
  name         = "${var.azurerm_postgresql_key_vault_secret_name}"
  value        = "${random_string.postgresql_administrator_login_password.result}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"

  lifecycle {
    ignore_changes = ["value"]
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_postgresql_server" "postgresql_server" {
  name                  = "${local.azurerm_postgresql_server_name}"
  location              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"

  # SKU: see https://docs.microsoft.com/en-us/rest/api/postgresql/servers/create#sku

  sku {
    # tier + family + cores (ie. B_Gen5_2)
    name     = "${var.azurerm_postgresql_server_sku_name}"

    # vcores
    capacity = "${var.azurerm_postgresql_server_sku_capacity}"

    # Basic, GeneralPurpose, MemoryOptimized
    tier     = "${var.azurerm_postgresql_server_sku_tier}"

    # Gen4, Gen5
    family   = "${var.azurerm_postgresql_server_sku_family}"
  }

  storage_profile {
    # es. 5120 = 5GB
    # see https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html
    storage_mb              = "${var.azurerm_postgresql_server_storage_mb}"
    backup_retention_days   = "${var.azurerm_postgresql_server_backup_retention_days}"
    # Enabled / Disabled
    auto_grow               = "${var.azurerm_postgresql_server_auto_grow}"
    # Enabled / Disabled
    geo_redundant_backup    = "${var.azurerm_postgresql_server_geo_redundant_backup}"
  }

  administrator_login          = "${var.azurerm_postgresql_administrator_login}"
  administrator_login_password = "${random_string.postgresql_administrator_login_password.result}"

  # 10, 11
  version                      = "${var.azurerm_postgresql_version}"

  # Enabled / Disabled
  ssl_enforcement              = "${var.azurerm_postgresql_server_ssl_enforcement}"

  tags = {
    environment = "${var.environment}"
  }
}

# PostgreSQL Virtual Network Rules can only be used
# with SKU Tiers of GeneralPurpose or MemoryOptimized

resource "azurerm_postgresql_virtual_network_rule" "postgresql_virtual_network_rule" {
  count                                = "${var.azurerm_postgresql_subnet_suffix != "" ? 1 : 0}"

  name                                 = "${azurerm_postgresql_server.postgresql_server.name}-net-${var.azurerm_postgresql_subnet_suffix}"
  resource_group_name                  = "${data.azurerm_resource_group.rg.name}"
  server_name                          = "${azurerm_postgresql_server.postgresql_server.name}"
  subnet_id                            = "${data.azurerm_subnet.subnet.id}"
  ignore_missing_vnet_service_endpoint = true
}
