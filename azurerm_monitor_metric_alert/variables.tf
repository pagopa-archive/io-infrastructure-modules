# Generic variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_monitor_action_group_name_suffix" {
  description = "Suffix for the monitor action group name."
}

# Specific variables for monitor action group

variable "alerts" {
  type        = "list"
  default     = []
  description = "A list of map(s) that contains one or more alert definition. Please read README.md to the list of keys required to be present"
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-SUFFIX
  azurerm_resource_group_name       = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_monitor_action_group_name = "${var.resource_name_prefix}-${var.environment}-monitor-ag-${var.azurerm_monitor_action_group_name_suffix}"
}
