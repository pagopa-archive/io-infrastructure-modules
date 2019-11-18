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
  default     = "Dynamic"
}

variable "application_gateway_hostname" {
  description = "The hostname of the application gateway (it's automatically postfixed by .env-name.domain)"
  default     = "api"
}

variable "application_gateway_name_suffix" {
  description = "The application gateway name suffix."
}

variable "azurerm_application_gateway_sku_name" {
  description = "The application gateway sku name."
  default     = "WAF_v2"
}

variable "azurerm_application_gateway_sku_tier" {
  description = "The application gateway sku tier"
  default     = "WAF_v2"
}

variable "azurerm_application_gateway_autoscaling_configuration_min_capacity" {
  description = "Minimum capacity for autoscaling."
  default     = "2"
}

variable "azurerm_application_gateway_autoscaling_configuration_max_capacity" {
  description = "Maximum capacity for autoscaling."
  default     = "4"
}

variable "azurerm_application_gateway_frontend_port_port" {
  description = "The port used for this Frontend Port."
  default     = "80"
}

variable "azurerm_application_gateway_waf_configuration_enabled" {
  description = "Enable the Web Application Firewall."
  default     = true
}

variable "azurerm_application_gateway_waf_configuration_firewall_mode" {
  description = "he Web Application Firewall Mode"
  default     = "Detection"
}

variable "azurerm_application_gateway_waf_configuration_rule_set_type" {
  description = "The Type of the Rule Set used for this Web Application Firewall."
  default     = "OWASP"
}

variable "azurerm_application_gateway_waf_configuration_rule_set_version" {
  description = "The Version of the Rule Set used for this Web Application Firewall."
  default     = "3.1"
}

variable "azurerm_application_gateway_backend_address_pool_ip_addresses" {
  description = "The private ip address associated to the APIM"
  type        = "list"
  default     = []
}

variable "azurerm_application_gateway_probe_interval" {
  description = "The Interval between two consecutive probes in seconds."
  default     = 30
}

variable "azurerm_application_gateway_probe_protocol" {
  description = "The Protocol used for this Probe."
  default     = "Http"
}

variable "azurerm_application_gateway_probe_timeout" {
  description = "The Timeout used for this Probe, which indicates when a probe becomes unhealthy."
  default     = 120
}

variable "azurerm_application_gateway_probe_unhealthy_threshold" {
  description = "The Unhealthy Threshold for this Probe, which indicates the amount of retries which should be attempted before a node is deemed unhealthy."
  default     = 8
}

variable "log_analytics_workspace_name" {
  description = "The Log Analytics workspace name."
  default     = "log-analytics-workspace"
}

variable "azurerm_application_gateway_diagnostic_logs_retention" {
  description = "The number of days for which this Retention Policy should apply."
  default     = 30
}

variable "azurerm_application_gateway_diagnostic_metrics_retention" {
  description = "The number of days for which this Retention Policy should apply."
  default     = 30
}

variable "public_ip_address_name_suffix" {
  description = "The suffix of the public IP address name."
}

variable "vnet_name_suffix" {
  description = "The name suffix of the virtual network."
}

variable "subnet_name_suffix" {
  description = "The name suffix of the subnet where nodes and external load balancers' IPs will be created."
}

locals {
  # Define resource names based on the following convention:
  # {resource_name_prefix}-{environment}-{resource_type}[-resource_name_suffix]
  azurerm_resource_group_name                                = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_key_vault_name                                     = "${var.resource_name_prefix}-${var.environment}-keyvault"
  azurerm_application_gateway_name                           = "${var.resource_name_prefix}-${var.environment}-ag-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_gateway_ip_configuration_name  = "${var.resource_name_prefix}-${var.environment}-ag-ip-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_frontend_port_name             = "${var.resource_name_prefix}-${var.environment}-ag-feport-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_probe_name                     = "${var.resource_name_prefix}-${var.environment}-ag-probe-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_backend_address_pool_name      = "${var.resource_name_prefix}-${var.environment}-ag-beap-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_frontend_ip_configuration_name = "${var.resource_name_prefix}-${var.environment}-ag-feip-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_backend_http_setting_name      = "${var.resource_name_prefix}-${var.environment}-ag-be-htst-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_http_listener_name             = "${var.resource_name_prefix}-${var.environment}-ag-httplstn-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_https_listener_name            = "${var.resource_name_prefix}-${var.environment}-ag-httpslstn-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_request_routing_rule_name      = "${var.resource_name_prefix}-${var.environment}-ag-rqrt-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_redirect_configuration_name    = "${var.resource_name_prefix}-${var.environment}-ag-rdrcfg-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_ssl_certificate_name           = "${var.resource_name_prefix}-${var.environment}-ag-ssl-${var.application_gateway_name_suffix}"
  azurerm_application_gateway_diagnostic_name                = "${var.resource_name_prefix}-${var.environment}-ag-diagnostic-${var.application_gateway_name_suffix}"
  azurerm_log_analytics_workspace_name                       = "${var.resource_name_prefix}-${var.environment}-log-analytics-workspace-${var.log_analytics_workspace_name}"
  azurerm_virtual_network_name                               = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name_suffix}"
  azurerm_subnet_name                                        = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name_suffix}"
  azurerm_public_ip_name                                     = "${var.resource_name_prefix}-${var.environment}-pip-${var.public_ip_address_name_suffix}"

  application_gateway_host_name                              = "${var.application_gateway_hostname}.${var.environment}.io.italia.it"
  azurerm_key_vault_secret_certificate                       = "application-gateway-${var.application_gateway_name_suffix}-cert"
}
