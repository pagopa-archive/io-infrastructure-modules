# Generic variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# Eventhub specific variables

variable "eventhub_name" {
  description = "The value that will be used as suffix to identify both the eventhub namespace and the eventhub."
}

variable "azurerm_eventhub_namespace_sku" {
  description = "The SKU of the eventhub namespace."
}

variable "azurerm_eventhub_namespace_capacity" {
  description = "The capacity of the eventhub namespace."
}

variable "azurerm_eventhub_partition_count" {
  description = "The eventhub partition count. Should be between 2 and 32."
}

variable "azurerm_eventhub_messege_retention" {
  description = "The eventhub data retention policy expressed in days."
}

variable "azurerm_eventhub_authorization_rules" {
  description = "The list of eventhub authorization rules. Each rule is expressed as a dictionary. Each dictionary can contain the keys name, listen, send, manage"
  type        = "list"
  default     = []
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name     = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_eventhub_namespace_name = "${var.resource_name_prefix}-${var.environment}-ehns-${var.eventhub_name}"
  azurerm_eventhub_name           = "${var.resource_name_prefix}-${var.environment}-eh-${var.eventhub_name}"
}
