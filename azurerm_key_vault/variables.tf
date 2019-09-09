variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_key_vault_tenant_id" {
  description = "The Azure AD ID"
}

variable "user_policies" {
  description = "A list of dictionaries representing the user's policies. The keys of each dictionary are mandatory and are: object_id, key_permissions, secret_permissions, certificate_permissions (see here for more details: https://www.terraform.io/docs/providers/azurerm/r/key_vault_access_policy.html)"
  type = "list"
}

variable "app_policies" {
  description = "A list of dictionaries representing the app's policies. The keys of each dictionary are mandatory and are: object_id, application_id, key_permissions, secret_permissions, certificate_permissions (see here for more details: https://www.terraform.io/docs/providers/azurerm/r/key_vault_access_policy.html)"
  type = "list"
}

locals {
  # Define resource names based on the following convention:
  # {resource_name_prefix}-{environment}-{resource_type}-{resource_name}
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_key_vault_name      = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
