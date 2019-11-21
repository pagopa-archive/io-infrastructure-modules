output "azurerm_kubernetes_cluster_name" {
  description = "The Azure AKS cluster name."
  value       = "${local.azurerm_kubernetes_cluster_name}"
}

output "azurerm_kubernetes_cluster_kubernetes_version" {
  description = "The Kubernetes version deployed."
  value       = "${var.azurerm_kubernetes_cluster_kubernetes_version}"
}

output "azurerm_kubernetes_cluster_linux_profile_admin_username" {
  description = "The Azure AKS cluster username."
  value       = "${var.azurerm_kubernetes_cluster_linux_profile_admin_username}"
}

output "azurerm_virtual_network_name" {
  description = "The Azure VNET used to host the PODs."
  value       = "${local.azurerm_virtual_network_name}"
}

output "azurerm_kubernetes_cluster_network_profile_service_cidr" {
  description = "The Network Range used by the Kubernetes service."
  value       = "${var.azurerm_kubernetes_cluster_network_profile_service_cidr}"
}

output "azurerm_kubernetes_cluster_network_profile_dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)."
  value       = "${var.azurerm_kubernetes_cluster_network_profile_dns_service_ip}"
}

output "azurerm_kubernetes_cluster_network_profile_docker_bridge_cidr" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes."
  value       = "${var.azurerm_kubernetes_cluster_network_profile_docker_bridge_cidr}"
}
