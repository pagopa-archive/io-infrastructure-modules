variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "azurerm_monitor_metric_alert_name" {
  description = "The name of the Metric Alert. Changing this forces a new resource to be created."
}

variable "azurerm_monitor_metric_alert_scopes" {
  description = "The resource ID at which the metric criteria should be applied."
}

variable "azurerm_monitor_metric_alert_description" {
  description = "The description of this Metric Alert."
}

variable "azurerm_monitor_metric_alert_criteria_metric_namespace" {
  description = "One of the metric namespaces to be monitored."
}

variable "azurerm_monitor_metric_alert_criteria_metric_name" {
  description = "One of the metric names to be monitored."
}

variable "azurerm_monitor_metric_alert_criteria_aggregation" {
  description = "The statistic that runs over the metric values. Possible values are Average, Count, Minimum, Maximum and Total."
}

variable "azurerm_monitor_metric_alert_criteria_operator" {
  description = "The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual."
}

variable "azurerm_monitor_metric_alert_criteria_treshold" {
  description = "The criteria threshold value that activates the alert."
}

variable "azurerm_monitor_action_group_name_suffix" {
  description = "Suffix for the monitor action group name."
}

locals {
  # Define resource names based on the following convention:  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name       = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_monitor_action_group_name = "${var.resource_name_prefix}-${var.environment}-monitor-ag-${var.azurerm_monitor_action_group_name_suffix}"
}
