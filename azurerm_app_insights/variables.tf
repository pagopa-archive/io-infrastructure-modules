# General Variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# App service plan specific variables

variable "azurerm_app_insights_name" {
  description = "The value that will be used as suffix to identify the app insights resource."
}
variable "azurerm_app_insights_application_type" {
  description = "the type of Application Insights."
}

locals {
    azurerm_resource_group_name   = "${var.resource_name_prefix}-${var.environment}-rg"
    azurerm_app_insights_name     = "${var.resource_name_prefix}-${var.environment}-ai-${var.azurerm_app_insights_name}"
}
