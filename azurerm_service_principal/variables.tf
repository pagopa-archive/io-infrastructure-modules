variable "environment" {
  description = "The nick name identifying the type of environment (i.e. dev, staging, production)"
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "app_name" {
  description = "The Azure application name"
}

variable "azurerm_role_assignment_role_definition_name" {
  description = "The role to assign to the service principal"
}

variable "azurerm_key_vault_name" {
  description = "The Azure key ault name."
}

variable "azurerm_key_vault_secret_name" {
  description = "The keyvault key for service principal secret"
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_key_vault_name      = "${var.resource_name_prefix}-${var.environment}-keyvault"
  azuread_application_name    = "${var.resource_name_prefix}-${var.environment}-sp-${var.app_name}"
}
