# Generic variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# Specific variables for monitor action group

variable "azurerm_monitor_action_group_name_suffix" {
  description = "Suffix for the monitor action group name."
}

variable "azurerm_monitor_action_group_short_name" {
  description = "Short name (1-12 characters) for the monitor group"
}

variable "azurerm_monitor_action_group_email_receiver_name" {
  description = "Unique name for the alerts receiver"
}

variable "azurerm_monitor_action_group_email_receiver_email_address" {
  description = "Email of the person or a distribution list to send alerts to"
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-SUFFIX
  azurerm_resource_group_name       = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_monitor_action_group_name = "${var.resource_name_prefix}-${var.environment}-monitor-ag-${var.azurerm_monitor_action_group_name_suffix}"
}
