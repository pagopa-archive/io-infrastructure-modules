variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "location" {
  description = "The location where the DNS zone will be created."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_public_ip_name" {
  description = "The suffix name of the public IP address to allocate."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name  = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_public_ip_name       = "${var.resource_name_prefix}-${var.environment}-pip-${var.azurerm_public_ip_name}"
}
