# Generic variables
variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# key_vault_certificate specific variables
variable "azurerm_key_vault_certificate_certificate_policy_issuer_parameters_name" {
  description = "description"
  default = "Self"
}
variable "azurerm_key_vault_certificate_certificate_policy_key_properties_exportable" {
  description = "Is this Certificate Exportable?"
  default = true
}

variable "azurerm_key_vault_certificate_certificate_policy_key_properties_size" {
  description = "The size of the Key used in the Certificate."
  default = 2048
}

variable "azurerm_key_vault_certificate_certificate_policy_key_properties_key_type" {
  description = "The Type of Key"
  default = "RSA"
}

variable "azurerm_key_vault_certificate_certificate_policy_key_properties_reuse_key" {
  description = "Is the key reusable?"
  default = true
}

variable "azurerm_key_vault_certificate_certificate_policy_lifetime_action_action_action_type" {
  description = "The Type of action to be performed when the lifetime trigger is triggerec."
  default = "AutoRenew"
}

variable "azurerm_key_vault_certificate_certificate_policy_lifetime_action_trigger_days_before_expiry" {
  description = "The number of days before the Certificate expires that the action associated with this Trigger should run."
  default = 30
}

variable "azurerm_key_vault_certificate_certificate_policy_secret_properties_content_type" {
  description = "The Content-Type of the Certificate"
  default = "application/x-pkcs12"
}
variable "azurerm_key_vault_certificate_certificate_policy_x509_certificate_properties" {
  type = "list"
  description = "A list of Extended/Enhanced Key Usages."
  default = ["1.3.6.1.5.5.7.3.1"]
}
variable "azurerm_key_vault_certificate_certificate_policy_key_usage" {
  type        = "list"
  description = "A list of uses associated with this Key."
  default     = ["cRLSign","dataEncipherment","digitalSignature","keyAgreement","keyCertSign","keyEncipherment"]
}

variable "azurerm_key_vault_certificate_certificate_policy_x509_certificate_properties_subject" {
  description = "The Certificate's Subject."
}
variable "azurerm_key_vault_certificate_certificate_policy__x509_certificate_properties_validity_in_months" {
  description = "The Certificates Validity Period in Months. "
  default = 12
}

locals {
  # Define resource names based on the following convention:
  # {resource_name_prefix}-{environment}-{resource_type}-{resource_name}
  azurerm_resource_group_name = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_key_vault_name      = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
