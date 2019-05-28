# General variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

# Service Principal related variables

variable "azurerm_key_vault_secret_name" {
  description = "The name of the service principal secret key."
}

# Log analytics related variables

variable "log_analytics_workspace_name" {
  description = "The name of the log analytics workspace. It will be used as the logs analytics workspace name suffix."
}

# AKS cluster related variables

variable "aks_cluster_name" {
  description = "The name suffix of the AKS cluster."
}

variable "azurerm_kubernetes_cluster_linux_profile_admin_username" {
  description = "The username for the admin account on cluster nodes."
}

variable "azurerm_kubernetes_cluster_agent_pool_profile_count" {
  description = "How many agent nodes in the cluster."
}

# See VM sizes https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes
variable "azurerm_kubernetes_cluster_agent_pool_profile_vm_size" {
  description = "Virtual machine size for agent nodes."
}

variable "azurerm_kubernetes_cluster_agent_pool_profile_max_pods" {
  description = "Maximum number of PODs allowed on each K8S node."
}

# Run az aks get-versions --location westeurope to see the versions available
variable "azurerm_kubernetes_cluster_kubernetes_version" {
  description = "The Kubernetes version to be used."
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key file, used to authorize initial SSH access to the machine."
}

# Network variables

variable "vnet_name" {
  description = "The name suffix of the virtual network where nodes and external load balancers' IPs will be created."
}

variable "subnet_name" {
  description = "The name suffix of the subnet where nodes and external load balancers' IPs will be created."
}

variable "azurerm_kubernetes_cluster_network_profile_pod_cidr" {
  description = "The CIDR to use for pod IP addresses."
}

variable "azurerm_kubernetes_cluster_network_profile_service_cidr" {
  description = "The Network Range used by the Kubernetes service."
}

variable "azurerm_kubernetes_cluster_network_profile_dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Must be .10 of the service cidr network specified."
}

variable "azurerm_kubernetes_cluster_network_profile_docker_bridge_cidr" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name                        = "${var.resource_name_prefix}-${var.environment}-rg"
  azurerm_azuread_service_principal_display_name     = "${var.resource_name_prefix}-${var.environment}-sp-${var.aks_cluster_name}"
  azurerm_virtual_network_name                       = "${var.resource_name_prefix}-${var.environment}-vnet-${var.vnet_name}"
  azurerm_subnet_name                                = "${var.resource_name_prefix}-${var.environment}-subnet-${var.subnet_name}"
  azurerm_log_analytics_workspace_name               = "${var.resource_name_prefix}-${var.environment}-log-analytics-workspace-${var.log_analytics_workspace_name}"
  azurerm_kubernetes_cluster_name                    = "${var.resource_name_prefix}-${var.environment}-aks-${var.aks_cluster_name}"
  # Agent pool profile cluster name cannot have dashes
  agent_pool_profile_cluster_name                    = "${replace(var.aks_cluster_name, "-", "")}"
  azurerm_kubernetes_cluster_agent_pool_profile_name = "${var.resource_name_prefix}${var.environment}${local.agent_pool_profile_cluster_name}"
  azurerm_key_vault_name                             = "${var.resource_name_prefix}-${var.environment}-keyvault"
}
