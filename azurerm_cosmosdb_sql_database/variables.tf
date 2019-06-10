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

variable "documentdb_name" {
  description = "Cosmos DB database name."
  default     = ""
}

variable "cosmosdb_account_name" {
  description = "Cosmos DB account name."
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}

  azurerm_resource_group_name      = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_cosmosdb_account_name    = "${var.resource_name_prefix}-${var.environment}-cosmosdb-${var.cosmosdb_account_name}"
  azurerm_cosmosdb_documentdb_name = "${var.resource_name_prefix}-documentdb-${var.environment}"
}
