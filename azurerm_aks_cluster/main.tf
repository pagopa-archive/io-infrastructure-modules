# The module brings up a Kubernetes cluster (in Azure AKS) of with an arbitrary
# number of nodes. Kubernetes nodes are automatically created by Azure in a
# separate resource group (name starting with MC). The Kubenet CNI plugin is used.
# 
# Nodes IP addreses are allocated in the subnet specified with subnet_id (so are reachable from other vnets)
#
# PODs have IPs in the pods_cidr specified (not directly reachable from other vnets)
#
# ClusterIPs are allocated in the service_cidr specified (not directly reachable from other vnets)
#
# Private external service IPs (for loadbalancers) are allocated in the same nodes subnet, specified
# with subnet_id (so are reachable from other vnets)
# 
# Public external service IPs (for loadbalancers) are directly allocated from Azure. To use a static
# public IP instead, look at the azure tutorials and documentation

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "aks_vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "aks_subnet" {
  name                 = "${local.azurerm_subnet_name}"
  virtual_network_name = "${data.azurerm_virtual_network.aks_vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

data "azuread_application" "application" {
  name = "${local.azurerm_azuread_service_principal_display_name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "${var.azurerm_key_vault_secret_ssh_public_key_name}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

data "azurerm_key_vault_secret" "aks_client_secret" {
  name         = "${var.azurerm_key_vault_secret_name}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.azurerm_log_analytics_workspace_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azuread_application" "application_aad_server" {
  name  = "${local.azuread_application_application_aad_server}"
}

data "azuread_application" "application_aad_client" {
  name  = "${local.azuread_application_application_aad_client}"
}

data "azurerm_key_vault_secret" "application_aad_server_sp_secret" {
  name         = "${var.azurerm_key_vault_secret_application_aad_server_sp_secret}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

# New infrastructure

resource "azurerm_log_analytics_solution" "log_analytics_solution" {
  solution_name         = "ContainerInsights"
  location              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  workspace_resource_id = "${data.azurerm_log_analytics_workspace.log_analytics_workspace.id}"
  workspace_name        = "${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "azurerm_kubernetes_cluster" {
  name                = "${local.azurerm_kubernetes_cluster_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  dns_prefix          = "${var.aks_cluster_name}"
  kubernetes_version  = "${var.azurerm_kubernetes_cluster_kubernetes_version}"

  linux_profile {
    admin_username = "${var.azurerm_kubernetes_cluster_linux_profile_admin_username}"

    ssh_key {
      key_data = "${data.azurerm_key_vault_secret.ssh_public_key.value}"
    }
  }

  agent_pool_profile {
    name           = "${local.azurerm_kubernetes_cluster_agent_pool_profile_name}"
    count          = "${var.azurerm_kubernetes_cluster_agent_pool_profile_count}"
    os_type        = "Linux"
    vm_size        = "${var.azurerm_kubernetes_cluster_agent_pool_profile_vm_size}"
    max_pods       = "${var.azurerm_kubernetes_cluster_agent_pool_profile_max_pods}"
    vnet_subnet_id = "${data.azurerm_subnet.aks_subnet.id}"
  }

  service_principal {
    client_id     = "${data.azuread_application.application.application_id}"
    client_secret = "${data.azurerm_key_vault_secret.aks_client_secret.value}"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.log_analytics_workspace.id}"
    }
  }

  network_profile {
    network_plugin     = "kubenet"
    pod_cidr           = "${var.azurerm_kubernetes_cluster_network_profile_pod_cidr}"
    service_cidr       = "${var.azurerm_kubernetes_cluster_network_profile_service_cidr}"
    dns_service_ip     = "${var.azurerm_kubernetes_cluster_network_profile_dns_service_ip}"
    docker_bridge_cidr = "${var.azurerm_kubernetes_cluster_network_profile_docker_bridge_cidr}"
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      client_app_id     = "${data.azuread_application.application_aad_client.application_id}"
      server_app_id     = "${data.azuread_application.application_aad_server.application_id}"
      server_app_secret = "${data.azurerm_key_vault_secret.application_aad_server_sp_secret.value}"
    }
  }

  tags {
    environment = "${var.environment}"
  }
}
