variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
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

variable "function_app_name" {
  description = "Function app name"
  default     = "undefined"
}

variable "virtualNetworkType" {
  description = "The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only."
  default     = "external"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"

  default = {}
}

variable "apim_groups" {
  description = "Api Management groups."
  default     = []
}

variable "apim_properties" {
  description = "Api Properties products."
  default     = []
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_apim_name           = "${var.resource_name_prefix}-${var.environment}-apim-${var.apim_name}"
  azurerm_function_app_name   = "${var.resource_name_prefix}-${var.environment}-fn-${var.function_app_name}"
}
