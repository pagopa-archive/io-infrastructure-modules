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

variable "resource_group_name" {
  description = "The name of the resources virtual group."
}

variable "infra_resource_group_name" {
  description = "The name of the infrastructure resource group."
}

variable "storage_account_resource_group_name" {
  description = "The name of the storage account resource group."
}

# Network Variables

variable "vnet_name" {
  description = "The name of the virtual network connecting all resources."
}

variable "subnet_name" {
  description = "The name of the virtual network subnet."
}

variable "azurerm_network_interface_ip_configuration_private_ip_address" {
  description = "The static private IP address to assign to the VM. It must be compatible with the subnet specified."
}

# Custom Image

variable "custom_image_name" {
  description = "The name of the custom image to use. The custom image should already exist"
}

# Storage account for VM boot diagnostics
variable "storage_account_name" {
  description = "The suffix used to identify the specific Azure storage account"
}

# Virtual Machine Variables

variable "vm_name" {
  description = "The name of the virtual machine."
}

variable "azurerm_virtual_machine_size" {
  description = "The size of the virtual machine."
}

variable "azurerm_virtual_machine_storage_os_disk_type" {
  description = "The managed OS disk type of the virtual machine."
  default     = "Standard_LRS"
}

variable "default_admin_username" {
  description = "The username of the administrator of the virtual machine."
}

variable "azurerm_key_vault_name" {
  description = "The Azure key vault name."
}

variable "azurerm_key_vault_secret_default_admin_password_name" {
  description = "The vault key containing the default Linux admin password."
}

variable "azurerm_key_vault_secret_ssh_public_key_name" {
  description = "The vault key containing the ssh public key to allow login without password."
}

variable "dns_private_zone_suffix" {
  description = "The Azure private DNS zone name suffix."
}

variable "dns_record_ttl" {
  description = "The TTL to be used while creating DNS records."
}

variable "public_ip" {
  description = "If a public IP should or should not be associated to the VM."
}

variable "azurerm_network_security_rules" {
  type        = "list"
  description = "The list of network security rules."
}

locals {
  azurerm_private_dns_zone_name                    = "${var.vnet_name}.${var.environment}.${var.dns_private_zone_suffix}"
  azurerm_virtual_machine_os_profile_computer_name = "${var.vm_name}.${local.azurerm_private_dns_zone_name}"

  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_virtual_network_name                     = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_subnet_name                              = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
  azurerm_storage_account_name                     = "${var.resource_name_prefix}${var.environment}sa${var.storage_account_name}"
  azurerm_virtual_machine_name                     = "${var.resource_name_prefix}-${var.environment}-vm-${var.vm_name}"
  azurerm_public_ip_name                           = "${var.resource_name_prefix}-${var.environment}-pip-${var.vm_name}"
  azurerm_network_security_group_name              = "${var.resource_name_prefix}-${var.environment}-sg-${var.vm_name}"
  azurerm_network_interface_name                   = "${var.resource_name_prefix}-${var.environment}-nic-${var.vm_name}"
  azurerm_network_interface_ip_configuration_name  = "${var.resource_name_prefix}-${var.environment}-nic-ip-config-${var.vm_name}"
  azurerm_virtual_machine_storage_os_disk_name     = "${var.resource_name_prefix}-${var.environment}-disk-os-${var.vm_name}"
}
