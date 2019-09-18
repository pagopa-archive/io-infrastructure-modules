# Generic variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# Specific variables for monitor action group

variable "web_tests" {
  type        = "list"
  default     = []
  description = "A list of map(s) that contains one or more web test definition. Please read README.md to the list of keys required to be present"
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-SUFFIX
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"
}
