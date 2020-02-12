variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_cdn_profile_suffix" {
  description = "CDN profile name."
}

variable "azurerm_cdn_profile_sku" {
  description = "One between Standard_Akamai, Standard_ChinaCdn, Standard_Microsoft, Standard_Verizon or Premium_Verizon."
  # Starting October 2019, If you are using Azure CDN from Microsoft, the cost of data transfer from Origins 
  # hosted in Azure to CDN PoPs is free of charge. Azure CDN from Verizon and Azure CDN from Akamai are not.
  default = "Standard_Microsoft"
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-suffix
  azurerm_resource_group_name    = "${var.resource_name_prefix}-${var.environment}-rg"

  azurerm_cdn_profile_name       = "${var.resource_name_prefix}-${var.environment}-cdn-${var.azurerm_cdn_profile_suffix}"
}
