# General Variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

###########

variable "storage_account_name" {
  description = "The suffix used to identify the specific Azure storage account."
}

variable "azurerm_storage_account_account_tier" {
  description = "The Azure storage account tier."
}

variable "azurerm_storage_account_account_replication_type" {
  description = "The Azure storage account replication type."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-suffix
  azurerm_resource_group_name  = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_storage_account_name = "${var.resource_name_prefix}${var.environment}sa${var.storage_account_name}"
}
