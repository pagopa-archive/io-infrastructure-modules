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

# DNS module specific variables

variable "aks_cluster_name" {
  description = "The name of the Kubernetes cluster."
}

variable "kubernetes_public_ip_name" {
  description = "The name suffix of the public IP address to allocate."
}

variable "dns_zone_prefix" {
  description = "The private Azure DNS name prefix."
  default     = ""
}

variable "dns_zone_suffix" {
  description = "The private Azure DNS name suffix."
}

variable "dns_record_ttl" {
  description = "The DNS records TTL in seconds."
}

variable "kubernetes_cname_records" {
  type        = "list"
  description = "The list of DNS CNAME records. Keys must include name, record (both string values)."
}

locals {
  kubernetes_public_ip_name                  = "${var.resource_name_prefix}-${var.environment}-pip-${var.kubernetes_public_ip_name}"
  private_prefix_environment_dns_zone_suffix = "${var.dns_zone_prefix}.${var.dns_zone_suffix}"
  azurerm_dns_zone_name                      = "${var.dns_zone_prefix != "" ? local.private_prefix_environment_dns_zone_suffix : var.dns_zone_suffix}"
  # Define resource names based on the following convention:
  # {resource_name_prefix}-{environment}-{resource_type}-{resource_name}
  azurerm_resource_group_name                = "${var.resource_name_prefix}-${var.environment}-rg"
}
