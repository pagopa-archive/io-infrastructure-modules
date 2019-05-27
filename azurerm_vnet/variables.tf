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
  description = "The name of the virtual network connecting all resources."
}

variable "azurerm_virtual_network_address_space" {
  description = "The address space of the virtual network connecting all resources."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name  = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_virtual_network_name = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
}
