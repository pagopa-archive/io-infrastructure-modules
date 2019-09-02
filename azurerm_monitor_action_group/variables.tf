variable "monitor_ag_name" {
  description = "Descriptive monitor group name"
}

variable "monitor_ag_short_name" {
  description = "Short name (1-12 characters) for the monitot group"
}

variable "email_receiver_unique_name" {
  description = "Unique name for the alerts receiver"
}

variable "email_receiver_email" {
  description = "Email of the person or a distribution list to send alerts to"
}

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

locals {
   azurerm_resource_group_name  = "${var.resource_name_prefix}-${var.environment}-rg"
}
