variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "plan_name" {
  description = "The App Service Plan name used by functionapp."
  default     = ""
}

variable "storage_account_name" {
  description = "The storage account name used by functionapp."
}

variable "functionapp_name" {
  description = "The name suffix of the functionapp."
}

variable "functionapp_settings" {
  default     = []
  description = "The list of dictionaries containing the application related settings. Each dictionary has a name and a value keys. Values depend by the application."
}

variable "functionapp_settings_secrets" {
  default     = []
  description = "The list of dictionaries containing the application related secret settings. Each dictionary has a name and a vault_alias keys (representing the key of the secret in the azure keyvault). Settings depend by the application."
}

variable "functionapp_connection_strings" {
  default     = []
  description = "Includes the authentication information required for your application to access data in an Azure Storage account at runtime using Shared Key authorization."
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name   = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_functionapp_name      = "${var.resource_name_prefix}-${var.environment}-fn-${var.functionapp_name}"
  azurerm_app_service_plan_name = "${var.resource_name_prefix}-${var.environment}-serviceplan-${var.plan_name}"

  azurerm_storage_account_name  = "${var.resource_name_prefix}${var.environment}sa${var.storage_account_name}"
  azurerm_key_vault_name        = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
