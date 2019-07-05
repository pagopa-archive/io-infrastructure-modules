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

variable "storage_account_name" {
  description = "The storage account name used by function_app"
}

variable "connectionStrings" {
  default     = []
  description = "includes the authentication information required for your application to access data in an Azure Storage account at runtime using Shared Key authorization"
}

variable "appSettings" {
  default     = []
  description = "Application settings."
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_functionapp_name      = "${var.resource_name_prefix}-functions-${var.environment}"
  azurerm_resource_group_name   = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_app_service_plan_name = "${var.resource_name_prefix}-${var.environment}-function-${var.plan_name}"
  azurerm_storage_account_name  = "${var.resource_name_prefix}${var.environment}sa${var.storage_account_name}"
  azurerm_key_vault_name        = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
