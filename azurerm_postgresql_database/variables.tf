variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_postgresql_server_name" {
  description = "Name of the PostgreSQL server"
}

variable "azurerm_postgresql_db_name" {
  description = "PostgreSQL default database name"
}

variable "azurerm_postgresql_db_collation" {
  description = "PostgreSQL default database collation (ie. English_United States.1252)"
  default = "und-x-icu"
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE-suffix
  azurerm_resource_group_name  = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_postgresql_server_name = "${var.resource_name_prefix}-${var.environment}-psql-${var.azurerm_postgresql_server_name}"
}
