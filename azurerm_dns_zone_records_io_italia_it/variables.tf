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

variable "kubernetes_resource_group_name" {
  description = "The resource group of the kubernetes cluster."
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

variable "aks_cluster_name_old" {
  description = "The name of the old (Agid) Kubernetes cluster."
}

variable "kubernetes_cname_records_old" {
  type        = "list"
  description = "The list of old Kubernetes (Agid) DNS CNAME records. Keys must include name, record (both string values)."
  default     = []
}

variable "developers_cname_records" {
  type        = "list"
  description = "The list of dictionaries with the name and the value of the developer portal related CNAME records."
}

variable "kubernetes_cname_records" {
  type        = "list"
  description = "The list of DNS CNAME records. Keys must include name, record (both string values)."
  default     = []
}

variable "mailgun_cname_record" {
  description = "The dictionary representing with the name and value of the MailGun API CNAME record."
  type        = "map"
}

variable "mailgun_mx_record" {
  description = "The dictionary representing with the name, and two valules with same preference -set to 10- value_a and value_b of the MailGun MX record."
  type        = "map"
}

variable "mailup_txt_records" {
  description = "The list of dictionaries with the name and the value of the MailUp related TXT records (DKIM, SPF)."
  type        = "list"
}

variable "mailup_cname_records" {
  description = "The list of dictionaries with the name and the value of the MailUp related CNAME records."
  type        = "list"
}

locals {
  private_prefix_environment_dns_zone_suffix = "${var.dns_zone_prefix}.${var.dns_zone_suffix}"
  azurerm_dns_zone_name                      = "${var.dns_zone_prefix != "" ? local.private_prefix_environment_dns_zone_suffix : var.dns_zone_suffix}"
  # Define resource names based on the following convention:
  # {resource_name_prefix}-{environment}-{resource_type}-{resource_name}
  azurerm_resource_group_name                = "${var.resource_name_prefix}-${var.environment}-rg"
}
