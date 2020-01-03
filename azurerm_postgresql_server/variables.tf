variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_postgresql_subnet_suffix" {
  description = "The suffix of the subnet of the PostgreSQL server (if one)."
  default = ""
}

variable "azurerm_postgresql_server_name" {
  description = "Name of the PostgreSQL server"
}

variable "azurerm_postgresql_server_sku_name" {
  description = "PostgreSQL sku composed by tier_family_cores (ie. GP_Gen5_2)"
}

variable "azurerm_postgresql_server_sku_capacity" {
  description = "PostgreSQL number of vcores"
}

variable "azurerm_postgresql_server_sku_tier" {
  description = "PostgreSQL server tier (Basic, GeneralPurpose, MemoryOptimized)"
}

variable "azurerm_postgresql_server_sku_family" {
  description = "PostgreSQL SKU family (Gen4, Gen5)"
}

variable "azurerm_postgresql_server_storage_mb" {
  description = "PostgreSQL server capacity in megabytes (ie. 5120 = 5GB)"
}

variable "azurerm_postgresql_server_backup_retention_days" {
  description = "PostgreSQL backup retention days ([7..35])"
}

variable "azurerm_postgresql_server_auto_grow" {
  description = "Activate PostgreSQL auto grow (Enabled / Disabled)"
}

variable "azurerm_postgresql_server_geo_redundant_backup" {
  description = "Activate PostgreSQL geo redundant backup (Enabled / Disabled)"
}

variable "azurerm_postgresql_administrator_login" {
  description = "PostgreSQL server username"
  default = "postgresql"
}

variable "azurerm_postgresql_key_vault_secret_name" {
  description = "The vault key to store PostgreSQL admin password"
}

variable "azurerm_postgresql_version" {
  description = "PostgreSQL server version (ie. 11)"
}

variable "azurerm_postgresql_server_ssl_enforcement" {
  description = "Set if the PostgreSQL server requires SSL connections (Enabled / Disabled)"
  default = "Enabled"
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-suffix
  azurerm_resource_group_name    = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_key_vault_name         = "${var.resource_name_prefix}-${var.environment}-keyvault"

  azurerm_postgresql_server_name = "${var.resource_name_prefix}-${var.environment}-psql-${var.azurerm_postgresql_server_name}"
}

