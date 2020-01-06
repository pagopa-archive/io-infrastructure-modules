variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_cdn_profile_suffix" {
  description = "CDN profile resource suffix."
}

variable "azurerm_cdn_endpoint_suffix" {
  description = "CDN endpoint resource suffix."
}

variable "azurerm_cdn_custom_domain_host_name" {
  description = "CDN custom domain host name. Must match an existing CNAME alias (add the dns zone suffix)."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-suffix
  azurerm_resource_group_name    = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_cdn_profile_name       = "${var.resource_name_prefix}-${var.environment}-cdn-${var.azurerm_cdn_profile_suffix}"

  azurerm_cdn_endpoint_name      = "${var.resource_name_prefix}-${var.environment}-cdn-endpoint-${var.azurerm_cdn_endpoint_suffix}"

  azurerm_cdn_custom_domain_name = "${replace(var.azurerm_cdn_custom_domain_host_name, ".", "-")}"
}
