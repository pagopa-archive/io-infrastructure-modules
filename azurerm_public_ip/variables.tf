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

# Needs to be expressed fully through a variable because sometimes resource groups need
# to be part of a special kubernetes resource group (automatically created), which does
# not follow the naming pattern used for other resources.

variable "azurerm_resource_group_name" {
  description = "The full name of the resource group where to create the public IP."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_public_ip_name = "${var.resource_name_prefix}-${var.environment}-pip-${var.azurerm_public_ip_name}"
}
