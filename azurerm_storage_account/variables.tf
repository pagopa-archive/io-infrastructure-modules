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

variable "storage_account_name" {
  description = "The suffix used to identify the specific Azure storage account"
}

variable "azurerm_storage_account_account_tier" {
  description = "The Azure storage account tier"
}

variable "azurerm_storage_account_account_replication_type" {
  description = "The Azure storage account replication type"
}

variable "allowed_subnets" {
  description = "The list of subnets allowed to access the storage account"
  type        = "list"
  default     = []
}

variable "allowed_ips" {
  description = "The list of IPs allowed to access the storage account"
  type        = "list"
  default     = []
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name  = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_storage_account_name = "${var.resource_name_prefix}${var.environment}sa${var.storage_account_name}"
}
