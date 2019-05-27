variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "x_vnet" {
  description = "The name of the source virtual network."
}

variable "y_vnet" {
  description = "The name of the destination virtual network."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name                      = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_virtual_network_y_vnet_name              = "${var.resource_name_prefix}-${var.environment}-vnet-${var.x_vnet}"
  azurerm_virtual_network_x_vnet_name              = "${var.resource_name_prefix}-${var.environment}-vnet-${var.y_vnet}"
  azurerm_virtual_network_peering_peering_x_y_name = "${var.resource_name_prefix}-${var.environment}-peering-${var.x_vnet}-${var.y_vnet}"
  azurerm_virtual_network_peering_peering_y_x_name = "${var.resource_name_prefix}-${var.environment}-peering-${var.y_vnet}-${var.x_vnet}"
}
