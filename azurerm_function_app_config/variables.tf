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

variable "functionapp_name" {
  description = "The name suffix of the functionapp."
}

variable "azurerm_functionapp_git_repo" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "azurerm_functionapp_git_branch" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "azurerm_functionapp_reservedInstanceCount" {
  description = "Number of reserved instances (to prevent cold start).This setting only applies to the Consumption and Premium Plan"
  default     = "1"
}

variable "website_git_provisioner" {
  description = "The short nick name identifying the type of environment (i.e. test, staging, production)"
  default     = "azurerm_website_git.ts"
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name  = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_functionapp_name     = "${var.resource_name_prefix}-${var.environment}-fn-${var.functionapp_name}"
  azurerm_virtual_network_name = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_subnet_name          = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
}
