variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_key_vault_ssh_keys_email" {
  description = "Email to use in ssh key generator"
}

variable "azurerm_key_vault_ssh_keys_private_secret_name" {
  description = "Name of the private ssh secret name to use"
}

variable "azurerm_key_vault_ssh_keys_public_secret_name" {
  description = "Name of the public ssh secret name to use"
}

locals {
  # Define resource names based on the following convention:
  # {resource_name_prefix}-{environment}-{resource_type}-{resource_name}
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_key_vault_name      = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
