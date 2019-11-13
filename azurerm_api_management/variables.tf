variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "apim_name" {
  description = "The API Management name."
}

variable "notification_sender_email" {
  type        = "string"
  description = "Email address from which the notification will be sent."
}

variable "publisher_email" {
  type        = "string"
  description = "Publisher email address"
}

variable "publisher_name" {
  type        = "string"
  description = "Publisher name"
}

variable "sku_name" {
  type        = "string"
  description = "Stock Keeping Unit Name"
  default     = "Consumption"
}

variable "sku_capacity" {
  description = "Stock Keeping Unit Capacity"
  default     = 1
}

variable "virtualNetworkType" {
  description = "The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only."
  default     = "external"
}
variable "hostname_configurations" {
  description = "hostname properties"
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"

  default = {}
}

variable "customProperties" {
  description = "Custom properties of the API Management service. Setting Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168 will disable the cipher TLS_RSA_WITH_3DES_EDE_CBC_SHA for all TLS(1.0, 1.1 and 1.2). Setting Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11 can be used to disable just TLS 1.1 and setting Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10 can be used to disable TLS 1.0 on an API Management service."
  type        = "map"

  default = {}
}

variable "vnet_name" {
  description = "The vnet name used by API management"
  default     = ""
}

variable "subnet_name" {
  description = "The subnet name used by API management"
  default     = ""
}

variable "hostname_configurations_hostname_prefix" {
  description = "The hostname_configurations hostname prefix. It's automatically suffixed by the environment and domain name."
  default     = ""
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name         = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_apim_name                   = "${var.resource_name_prefix}-${var.environment}-apim-${var.apim_name}"
  azurerm_virtual_network_name        = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_subnet_name                 = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
  azurerm_key_vault_name              = "${var.resource_name_prefix}-${var.environment}-keyvault"
  hostname_configurations_hostname    = "${var.hostname_configurations_hostname_prefix}.${var.environment}.io.italia.it"
  hostname_configurations_keyvault_id = "https://${local.azurerm_key_vault_name}.vault.azure.net/secrets/generated-cert"
}
