### General Variables

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

variable "subnet_name" {
  description = "The name of the virtual network connecting all resources."
}

variable "azurerm_subnet_address_prefix" {
  description = "The address prefix of the subnet where the virtual machine will be put into."
}

variable "azurerm_subnet_service_endpoints" {
  description = "The list of service endpoints."
  default     = []
}

variable "add_route_table" {
  description = "If to add or not a route table to the subnet."
  default     = false
}

variable "azurerm_routes" {
  description = "The list of optional routes to add to the routing table."
  type        = "list"
  default     = []
}

variable "add_security_group" {
  description = "If to add or not a security group to the subnet."
  default     = false
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name         = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_virtual_network_name        = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_route_table_name            = "${var.resource_name_prefix}-${var.environment}-route-table-${var.subnet_name}"
  azurerm_subnet_name                 = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
  azurerm_network_security_group_name = "${var.resource_name_prefix}-${var.environment}-sg-${var.subnet_name}"
}
