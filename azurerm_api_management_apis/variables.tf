variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "apim_name" {
  description = "The API Management name."
}

variable "apim_apis" {
  description = "APIs."
  default     = []
}

variable "apim_api_operations" {
  description = "API operations."
  default     = []
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_apim_name           = "${var.resource_name_prefix}-${var.environment}-apim-${var.apim_name}"

  api_management_default_api_operation_policy = "${file("default_api_operation_policy.xml")}"
}
