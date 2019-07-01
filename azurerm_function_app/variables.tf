variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "plan_name" {
  description = "The App Service Plan name used by function_app"
  default     = ""
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_functionapp_name    = "${var.resource_name_prefix}-functions-${var.environment}"
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_app_service_plan_name = "${var.resource_name_prefix}-${var.environment}-function-${var.plan_name}"
}
