variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "location" {
  description = "The location where the DNS zone will be created."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "dns_zone_prefix" {
  description = "The private Azure DNS name prefix."
  default     = ""
}

variable "dns_zone_suffix" {
  description = "The private Azure DNS name suffix."
}

variable "azurerm_dns_zone_zone_type" {
  description = "The Azure DNS zone type. It can be either Private or Public. If it's public, all records will be publicly resolved."
}

variable "registration_vnets" {
  type        = "list"
  default     = []
  description = "The optional list of the VNETs for which host names will be automatically registered (max allowed 1)."
}

variable "resolution_vnets" {
  type        = "list"
  default     = []
  description = "The optional list of the VNETs that are allowed to resolve names for this DNS private zone."
}

variable "add_environment" {
  description = "Whether or not to add the environment variable to the domain prefix."
  default     = true
}

locals {
  environment_dns_zone_suffix                = "${var.environment}.${var.dns_zone_suffix}"
  dns_zone_suffix                            = "${var.add_environment ? local.environment_dns_zone_suffix : var.dns_zone_suffix}"
  private_prefix_environment_dns_zone_suffix = "${var.dns_zone_prefix}.${local.dns_zone_suffix}"
  azurerm_virtual_network_registration_name  = "${formatlist("%s-%s-vnet-%s", var.resource_name_prefix, var.environment, var.registration_vnets)}"
  azurerm_virtual_network_resolution_name    = "${formatlist("%s-%s-vnet-%s", var.resource_name_prefix, var.environment, var.resolution_vnets)}"
  azurerm_dns_zone_name                      = "${var.dns_zone_prefix != "" ? local.private_prefix_environment_dns_zone_suffix : local.dns_zone_suffix}"

  # Define resource names based on the following convention:
  # {resource_name_prefix}-{environment}-{resource_type}-{resource_name}
  azurerm_resource_group_name                = "${var.resource_name_prefix}-${var.environment}-rg"
}
