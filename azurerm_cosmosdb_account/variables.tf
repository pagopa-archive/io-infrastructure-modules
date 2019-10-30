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

# CosmosDB specific variables

variable "cosmosdb_account_name" {
  description = "The suffix used for the CosmosDB name."
}

variable "azurerm_cosmosdb_account_offer_type" {
  description = "The CosmosDB account offer type. At the moment can only be set to Standard"
  default     = "Standard"
}

variable "azurerm_cosmosdb_account_kind" {
  description = "Specifies the Kind of CosmosDB to create - possible values are GlobalDocumentDB and MongoDB."
}

variable "azurerm_cosmosdb_account_consistency_policy" {
  description = "Specifies a consistency_policy resource, used to define the consistency policy for this CosmosDB account. It's a dictionary. Values are consistency_level (BoundedStaleness, Eventual, Session or Strong), and optionally max_interval_in_seconds, max_staleness_prefix."
  type        = "map"
}

variable "allowed_vnet_suffix" {
  description = "The name of the virtual network allowed to access CosmosDB."
}

variable "allowed_subnets_suffix" {
  description = "A list of the name suffixes of the subnets allowed to access CosmosDB. For example, for io-dev-subnet-fn2app would be fn2app."
  type        = "list"
  default     = []
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name   = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_virtual_network_name  = "${var.resource_name_prefix}-${var.environment}-vnet-${var.allowed_vnet_suffix}"
  azurerm_cosmosdb_account_name = "${var.resource_name_prefix}-${var.environment}-cosmosdb-${var.cosmosdb_account_name}"
  azurerm_key_vault_name        = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
