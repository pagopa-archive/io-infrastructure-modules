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

variable "container_name" {
  description = "Cosmos DB container name."
}

variable "documentdb_name" {
  description = "Cosmos DB database name."
  default     = ""
}

variable "partitionKey_paths" {
  description = "List of paths using which data within the container can be partitioned"
  default     = []
}

variable "indexingMode" {
  description = "Specifies the supported indexing modes in the Azure Cosmos DB service."
  default     = "consistent"
}

variable "includedPaths" {
  description = "Specifies a path within a JSON document to be included in the Azure Cosmos DB service."
  default     = []
}

variable "cosmosdb_account_name" {
  description = "Cosmos DB account name."
}

variable "container_throughput" {
  description = "The throughput to assign to the container."
  default     = 400
}

locals {
  # Define resource names based on the following convention:  {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}

  azurerm_resource_group_name      = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_cosmosdb_account_name    = "${var.resource_name_prefix}-${var.environment}-cosmosdb-${var.cosmosdb_account_name}"
  azurerm_cosmosdb_documentdb_name = "${var.resource_name_prefix}-${var.environment}-sqldb-${var.documentdb_name}"
}
