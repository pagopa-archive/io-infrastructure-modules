variable "create" {
  description = "Controls if terraform resources should be created (it affects almost all resources)"
  default     = true
}

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# TF_VAR_ADB2C_TENANT_ID
variable "ADB2C_TENANT_ID" {
  type        = "string"
  description = "Name of the Active Directory B2C tenant used in the API management portal authentication flow"
  default     = "agidweb"
}

variable "app_settings" {
  default     = {}
  type        = "map"
  description = "Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
}

# variable "notification_sender_email" {
#   type        = "string"
#   description = "Email address for notifications"
# }

variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

# variable "publisher_email" {
#   type        = "string"
#   description = "Publisher email address"
# }

# variable "publisher_name" {
#   type        = "string"
#   description = "Publisher name"
# }

variable "sku_name" {
  type        = "string"
  description = ""
  default     = "Consumption"
}

variable "sku_capacity" {
  description = ""
  default     = 1
}

variable "key_vault_id" {
  description = ""
}

variable "azurerm_function_app_name" {
  default = "undefined"
}

# variable "environment_short" {
#   description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
# }

# NOTE: connection_string cannot be passed due to an internal terraform limit 
# (https://github.com/hashicorp/terraform/issues/16582#issuecomment-342570913 and 
# https://github.com/hashicorp/terraform/issues/7034 ).
# As workaround we pass only string values (see variables following) 
# variable "connection_string" {
#   description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
#   type= "list"
#   default = [
#     {
# name = "invalid"
# type = "Custom"
# value = "https://invalid"
#   },
#   ]
# }

variable "cosmosdb_key" {
  default     = "COSMOSDB_KEY used in connection_string, see above"
  description = "..."
}

variable "cosmosdb_uri" {
  default     = "COSMOSDB_URI used in connection_string, see above "
  description = "..."
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"

  default = {}
}

variable "azurerm_functionapp_git_repo" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "azurerm_functionapp_git_branch" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "website_git_provisioner" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "account_replication_type" {
  default     = "LRS"
  description = "The Storage Account replication type. See azurerm_storage_account module for posible values."
}

variable "azurerm_functionapp_storage_account_name" {
  description = "The storage account name used by function_app"
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_functionapp_name = "${var.resource_name_prefix}-functions-${var.environment}"
  # = "${var.resource_name_prefix}funcstorage${var.environment}"
  azurerm_app_service_plan_name            = "${var.resource_name_prefix}-app-${var.environment}"
}