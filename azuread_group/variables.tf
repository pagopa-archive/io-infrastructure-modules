# General variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# Azuread group specific variables

variable "group_name_suffix" {
  description = "The name suffix of the group to create."
}

variable "group_members_user_principal_name" {
  description = "List of user principal names to add to the group."
  type        = "list"
  default     = []
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE[-suffix]
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"
  azuread_group_name          = "${var.resource_name_prefix}-${var.environment}-group-${var.group_name_suffix}"
}
