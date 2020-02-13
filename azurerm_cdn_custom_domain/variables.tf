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

variable "dns_zone_name" {
  description = "The Azure DNS name suffix."
}

variable "dns_record_ttl" {
  description = "The DNS records TTL in seconds."
}

variable "cname_record" {
  description = "The CNAME DNS record value."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-suffix
  azurerm_resource_group_name                = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_cdn_profile_name                   = "${var.resource_name_prefix}-${var.environment}-cdn-${var.azurerm_cdn_profile_suffix}"

  azurerm_cdn_endpoint_name                  = "${var.resource_name_prefix}-${var.environment}-cdn-endpoint-${var.azurerm_cdn_endpoint_suffix}"

  azurerm_cdn_endpoint_hostname              = "${var.resource_name_prefix}-${var.environment}-cdn-endpoint-${var.azurerm_cdn_endpoint_suffix}.azureedge.net"

  azurerm_cdn_custom_domain_host_name        = "${var.cname_record}.${var.dns_zone_name}"

  azurerm_cdn_custom_domain_name             = "${replace("${var.cname_record}.${var.dns_zone_name}", ".", "-")}"
}
