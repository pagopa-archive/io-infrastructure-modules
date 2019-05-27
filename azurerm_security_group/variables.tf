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

# Security group related variables

variable "azurerm_network_security_group_name" {
  description = "The name of the security group used as the suffix of the full name."
}

variable "azurerm_network_security_rules" {
  type        = "list"
  description = "The list of network security rules."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name         = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_network_security_group_name = "${var.resource_name_prefix}-${var.environment}-sg-${var.azurerm_network_security_group_name}"
}
