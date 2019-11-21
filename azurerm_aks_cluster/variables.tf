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

variable "azurerm_key_vault_secret_ssh_public_key_name" {
  description = "The name of the SSH key secret stored in the Azure Keyvault."
}

variable "azurerm_kubernetes_cluster_agent_pool_profile_min_count" {
  description = "The minimum number of agent nodes."
}

variable "azurerm_kubernetes_cluster_agent_pool_profile_max_count" {
  description = "The maximum number of agent nodes."
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

# Network variables

variable "vnet_name" {
  description = "The name suffix of the virtual network where nodes and external load balancers' IPs will be created."
}

variable "subnet_name" {
  description = "The name suffix of the subnet where nodes and external load balancers' IPs will be created."
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

# AAD integration

variable "app_name_k8s_aad_server" {
  description = "The k8s aad server Azure application name. Defaults to k8s-aad-server)"
  default     = "k8s-01-aad-server"
}

variable "app_name_k8s_aad_client" {
  description = "The k8s aad client Azure application name. Defaults to k8s-aad-client)"
  default     = "k8s-01-aad-client"
}

variable "azurerm_key_vault_secret_application_aad_server_sp_secret" {
  description = "The key of the Azure Keyvault secret containing the aad_server_sp secret. Defaults to k8s-01-aad-server-sp-secret."
  default     = "k8s-01-aad-server-sp-secret"
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
  azurerm_kubernetes_cluster_agent_pool_profile_name = "${var.resource_name_prefix}${substr(var.environment, 0, 2)}${local.agent_pool_profile_cluster_name}"
  azurerm_key_vault_name                             = "${var.resource_name_prefix}-${var.environment}-keyvault"
  azuread_application_application_aad_client         = "${var.resource_name_prefix}-${var.environment}-sp-${var.app_name_k8s_aad_client}"
  azuread_application_application_aad_server         = "${var.resource_name_prefix}-${var.environment}-sp-${var.app_name_k8s_aad_server}"
}
