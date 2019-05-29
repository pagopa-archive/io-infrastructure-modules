# General variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

# Log analytics workspace related variables

variable "azurerm_log_analytics_workspace_sku" {
  description = "The SKU of the log analytics workspace. The only option after 2018-04-03 is PerGB2018. See here for more details: http://aka.ms/PricingTierWarning"
  default     = "PerGB2018"
}

variable "azurerm_log_analytics_workspace_retention_in_days" {
  description = "The number of data retention in days."
}

variable "log_analytics_workspace_name" {
  description = "The name of the log analytics workspace. It will be used as the logs analytics workspace name suffix."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name          = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_log_analytics_workspace_name = "${var.resource_name_prefix}-${var.environment}-log-analytics-workspace-${var.log_analytics_workspace_name}"
}
