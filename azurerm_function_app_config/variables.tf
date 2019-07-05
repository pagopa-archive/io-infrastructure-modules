variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "vnet_name" {
  description = "The vnet name used by function_app"
  default     = ""
}

variable "subnet_name" {
  description = "The subnet name used by function_app"
  default     = ""
}

variable "plan_name" {
  description = "The App Service Plan name used by function_app"
  default     = ""
}

variable "azurerm_functionapp_git_repo" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "azurerm_functionapp_git_branch" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "website_git_provisioner" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
  default     = "azurerm_website_git.ts"
}

# variable "azurerm_key_vault_tenant_id" {
#   description = "The Azure AD ID"
# }

variable "storage_account_name" {
  description = "The storage account name used by function_app"
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_functionapp_name    = "${var.resource_name_prefix}-functions-${var.environment}"
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_storage_account_name = "${var.resource_name_prefix}${var.environment}sa${var.storage_account_name}"
  azurerm_virtual_network_name = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_subnet_name          = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
}
