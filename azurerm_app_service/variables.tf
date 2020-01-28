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

# App Service specific variables
variable "docker_image" {
  description = "The docker image and tag."
}

variable "docker_registry_server_username" {
  description = "The docker registry username."
  default     = ""
}

variable "docker_registry_server_url" {
  description = "The docker registry url, default to docker-hub."
  default     = "https://index.docker.io"
}

variable "docker_registry_server_password" {
  description = "The docker registry password."
  default     = ""
}
variable "websites_enable_app_service_storage" {
  description = "If you need files to be persisted in scale operations or across restarts, you should add this app setting and set it to true. If you don't require file persistence, you can set this app setting to false."
  default     = "false"
}

variable "virtual_network_subnet_id" {
  description = "The subnet id used for access restriction"
  default     = ""
}
variable "app_name_suffix" {
  description = "description"
  default     = ""
}

variable "service_plan_name_suffix" {
  description = "description"
  default     = ""
}
variable "resource_name_suffix" {
  description = "description"
  default     = ""
}

variable "app_service_diagnostic_logs_retention" {
  description = "The retention days of logs."
  default     = 30
}
variable "log_analytics_workspace_name" {
  description = "The Log Analytics workspace name."
  default     = "log-analytics-workspace"
}
variable "ip_restriction" {
  description = "description"
  default     = false
}
variable "subnet_id" {
  description = "The subnet id."
  default = ""
}
variable "vnet_name" {
  description = "The name suffix of the virtual network where nodes and external load balancers' IPs will be created."
}

variable "subnet_name" {
  description = "The name suffix of the subnet where nodes and external load balancers' IPs will be created."
}
variable "app_service_settings" {
  description = "The list of parameter used by app_service."
  default     = {}
}
variable "app_service_settings_secrets" {
  description = "The list of parameter that are stored on keyvault."
  default     = []
}

locals {
  # Define resource names based on the following convention:
  # {resource_name_prefix}-{environment}-{resource_type}[-resource_name_suffix]
  azurerm_resource_group_name          = "${var.resource_name_prefix}-${var.environment}${var.resource_name_suffix != "" ? "-${var.resource_name_suffix}-" : "-"}rg"
  azurerm_resource_group_name_main     = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_service_plan_name            = "${var.resource_name_prefix}-${var.environment}-serviceplan${var.service_plan_name_suffix != "" ? "-${var.service_plan_name_suffix}" : ""}"
  azurerm_app_name                     = "${var.resource_name_prefix}-${var.environment}-app${var.app_name_suffix != "" ? "-${var.app_name_suffix}" : ""}"
  azurerm_log_analytics_workspace_name = "${var.resource_name_prefix}-${var.environment}-log-analytics-workspace-${var.log_analytics_workspace_name}"
  azurerm_app_service_diagnostic_name  = "${var.resource_name_prefix}-${var.environment}-app-diagnostic-${var.app_name_suffix}"
  azurerm_virtual_network_name         = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_subnet_name                  = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
  azurerm_key_vault_name               = "${var.resource_name_prefix}-${var.environment}-keyvault"
  app_settings_secret_map              = "${zipmap(data.null_data_source.app_service_settings_secrets.*.outputs.key, data.null_data_source.app_service_settings_secrets.*.outputs.value)}"

  app_settings_default_secret          = [
    {
      name        = "APPINSIGHTS_INSTRUMENTATIONKEY"
      vault_alias = "${var.resource_name_prefix}-${var.environment}-${local.azurerm_app_name}-appinsights-instrumentationkey"
    }
  ]
  app_settings_default                 = [
    {
      name  = "DOCKER_REGISTRY_SERVER_USERNAME"
      value = ""
    }
  ]
}
