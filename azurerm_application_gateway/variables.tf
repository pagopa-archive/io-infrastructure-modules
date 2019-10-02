# General Variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

# Application Gateway plan specific variables
variable "azurerm_public_ip_allocation_method" {
  description = "The public ip associated to the Application Gateway."
  default = "Dynamic"
}

variable "azurerm_application_gateway_sku_name" {
  description = "The application gateway sku name."
}
variable "azurerm_application_gateway_sku_tier" {
  description = "The application gateway sku tier"
}

variable "azurerm_application_gateway_autoscaling_configuration_min_capacity" {
  description = "Minimum capacity for autoscaling."
  default = "2"
}

variable "azurerm_application_gateway_autoscaling_configuration_max_capacity" {
  description = "Maximum capacity for autoscaling."
  default = "2"
}
variable "azurerm_application_gateway_frontend_port_port" {
  description = "The port used for this Frontend Port."
  default = "443"
}
variable "azurerm_application_gateway_waf_configuration_enabled" {
  description = "Enable the Web Application Firewall."
  default = true
}
variable "azurerm_application_gateway_waf_configuration_firewall_mode" {
  description = "he Web Application Firewall Mode"
  default = "Prevention"
}
variable "azurerm_application_gateway_waf_configuration_rule_set_type" {
  description = "The Type of the Rule Set used for this Web Application Firewall."
  default = "OWASP"
}
variable "azurerm_application_gateway_waf_configuration_rule_set_version" {
  description = "The Version of the Rule Set used for this Web Application Firewall."
  default = "3.1"
}

locals {
  azurerm_resource_group_name                                = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_application_gateway_name                           = "${var.resource_name_prefix}-${var.environment}-ag"
  azurerm_application_gateway_gateway_ip_configuration_name  = "${var.resource_name_prefix}-${var.environment}-ag-ip"
  azurerm_application_gateway_frontend_port_name             = "${var.resource_name_prefix}-${var.environment}-ag-feport"
  azurerm_application_gateway_backend_address_pool_name      = "${var.resource_name_prefix}-${var.environment}-ag-beap"

  azurerm_application_gateway_frontend_ip_configuration_name = "${var.resource_name_prefix}-${var.environment}-ag-feip"
  azurerm_application_gateway_backend_http_setting_name      = "${var.resource_name_prefix}-${var.environment}-ag-be-htst"
  azurerm_application_gateway_http_listener_name                  = "${var.resource_name_prefix}-${var.environment}-ag-httplstn"
  azurerm_application_gateway_request_routing_rule_name      = "${var.resource_name_prefix}-${var.environment}-ag-rqrt"
  azurerm_application_gateway_redirect_configuration_name    = "${var.resource_name_prefix}-${var.environment}-ag-rdrcfg"
}

