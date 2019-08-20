# Generic variables
variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# Notification Hub related variables

variable "notification_hub_name" {
  description = "The name of the notification hub."
}

variable "azurerm_notification_hub_namespace_sku_name" {
  description = "The SKU name of the notification hub namespace."
}

variable "azurerm_notification_hub_apns_credential_application_mode" {
  description = "The Application Mode which defines which server the APNS Messages should be sent to."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name             = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_notification_hub_namespace_name = "${var.resource_name_prefix}-${var.environment}-nhns-${var.notification_hub_name}"
  azurerm_notification_hub_name           = "${var.resource_name_prefix}-${var.environment}-nh-${var.notification_hub_name}"
  azurerm_key_vault_name                  = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
