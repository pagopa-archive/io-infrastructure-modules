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

variable "cosmosdb_key" {
  default     = "COSMOSDB_KEY used in connection_string, see above"
  description = "..."
}

variable "cosmosdb_uri" {
  default     = "COSMOSDB_URI used in connection_string, see above "
  description = "..."
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

variable "functions_extension_version" {
  description = "The version of the Functions runtime"
  default     = "~1"
}

variable "functions_worker_runtime" {
  description = "The language worker runtime to load in the function app. This will correspond to the language being used in your application (for example, 'dotnet'). For functions in multiple languages you will need to publish them to multiple apps, each with a corresponding worker runtime value. Valid values are dotnet (C#/F#), node (JavaScript/TypeScript), java (Java), powershell (PowerShell), and python (Python)."
  default     = "node"
}

variable "website_node_default_version" {
  default = "8.11.1"
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_functionapp_name    = "${var.resource_name_prefix}-functions-${var.environment}"
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_storage_account_name  = "${var.resource_name_prefix}${var.environment}sa${var.storage_account_name}"
  azurerm_virtual_network_name  = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_subnet_name           = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
  azurerm_app_service_plan_name = "${var.resource_name_prefix}-${var.environment}-function-${var.plan_name}"

  # azurerm_key_vault_name        = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
