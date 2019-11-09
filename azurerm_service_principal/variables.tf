variable "environment" {
  description = "The nick name identifying the type of environment (i.e. dev, staging, production)"
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "app_name" {
  description = "The Azure application name"
}

variable "app_name_k8s_aad_server" {
  description = "The k8s aad server Azure application name (to be specific when creating service principals of type k8s_aad_client. Defaults to k8s-aad-server)"
  default     = "k8s-01-aad-server"
}

variable "app_type" {
  description = "Defines what Azure app registration gets deployed. Can be generic, k8s_aad_server, k8s_aad_client. Defaults to generic."
  default     = "generic"
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

variable "azurerm_key_vault_tenant_id" {
  description = "The Azure AD ID"
}

variable "add_to_keyvault_access_policy" {
  description = "Whether or not to add the service principal to the access list of the Azure keyvault to allow secrets read."
  default     = false
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name             = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_key_vault_name                  = "${var.resource_name_prefix}-${var.environment}-keyvault"
  azuread_application_name                = "${var.resource_name_prefix}-${var.environment}-sp-${var.app_name}"
  azuread_application_name_k8s_aad_server = "${var.resource_name_prefix}-${var.environment}-sp-${var.app_name_k8s_aad_server}"
}
