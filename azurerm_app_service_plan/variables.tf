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

variable "azurerm_app_service_plan_sku_tier" {
  description = "The sku tier associated with App service plan"
}

variable "azurerm_app_service_plan_sku_size" {
  description = "The sku size of the App service plan"
}

variable "azurerm_app_service_plan_kind" {
  description = "The kind of the App Service Plan to create"
}

variable "azurerm_app_service_plan_suffix" {
  description = "The App service plan suffix name"
}

variable "azurerm_app_service_plan_sku_capacity" {
  description = "The number of workers associated with this App Service Plan"
  default     = ""
}

locals {
  azurerm_app_service_plan_name = "${var.resource_name_prefix}-${var.environment}-serviceplan-${var.azurerm_app_service_plan_suffix}"
  azurerm_resource_group_name   = "${var.resource_name_prefix}-${var.environment}-rg"
}
