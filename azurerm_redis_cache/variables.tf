variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "storage_account_name" {
  description = "The suffix used to identify the specific Azure storage account."
}

variable "vnet_name" {
  description = "The name of the virtual network connecting all resources."
}

variable "subnet_name" {
  description = "The name of the virtual network connecting all resources."
}

variable "redis_cache_name_suffix" {
  description = "The suffix of the redis cache name."
}

variable "azurerm_redis_cache_capacity" {
  description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1 (6GB), 2 (13GB), 3 (26GB), 4 (53GB)."
}

variable "azurerm_redis_cache_shard_count" {
  description = "(Optional) Only available when using the Premium SKU The number of Shards to create on the Redis Cluster."
}

variable "azurerm_redis_cache_enable_non_ssl_port" {
  description = "(Optional) Enable the non-SSL port (6379) - disabled by default."
  default     = false
}

variable "azurerm_redis_cache_redis_configuration_rdb_backup_frequency" {
  description = "(Optional) The Backup Frequency in Minutes. Only supported on Premium SKU's. Possible values are: 15, 30, 60, 360, 720 and 1440"
  default     = ""
}

variable "azurerm_redis_cache_redis_configuration_rdb_backup_max_snapshot_count" {
  description = "(Optional) The maximum number of snapshots to create as a backup. Only supported for Premium SKU's."
  default     = ""
}

variable "azurerm_redis_cache_redis_configuration_rdb_backup_enabled" {
  description = "(Optional) Is Backup Enabled? Only supported on Premium SKU's."
  default     = false
}

variable "azurerm_redis_cache_private_static_ip_address" {
  description = "The static IP address to be assigned to the Redis cache. Must be compatible with the address space of the subnet declared."
}

variable "azurerm_redis_cache_family" {
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)."
}

variable "azurerm_redis_cache_sku_name" {
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name  = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_storage_account_name = "${var.resource_name_prefix}${var.environment}sa${var.storage_account_name}"
  azurerm_virtual_network_name = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_subnet_name          = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
  azurerm_redis_cache_name     = "${var.resource_name_prefix}-${var.environment}-redis-${var.redis_cache_name_suffix}"
}
