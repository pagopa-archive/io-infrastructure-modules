variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_cdn_endpoint_profile_suffix" {
  description = "Name of the CDN profile resource this endpoint belongs to."
}

variable "azurerm_cdn_endpoint_is_http_allowed" {
  description = "Boolean flag that set if http is allowed"
  default = false
}

variable "azurerm_cdn_endpoint_is_https_allowed" {
  description = "Boolean flag that set if https is allowed"
  default = true
}

variable "azurerm_cdn_endpoint_querystring_caching_behaviour" { 
  description = "One between IgnoreQueryString, BypassCaching and UseQueryString."
  default = "IgnoreQueryString"
}

variable "origin_storage_account_suffix" {
  description = "Origin storage account short name (without prefix)."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-suffix
  azurerm_resource_group_name        = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_storage_account_name       = "${var.resource_name_prefix}${var.environment}sa${var.origin_storage_account_suffix}"

  azurerm_cdn_endpoint_name          = "${var.resource_name_prefix}-${var.environment}-cdn-endpoint-${var.origin_storage_account_suffix}"

  azurerm_cdn_endpoint_profile_name  = "${var.resource_name_prefix}-${var.environment}-cdn-${var.azurerm_cdn_endpoint_profile_suffix}"
}
