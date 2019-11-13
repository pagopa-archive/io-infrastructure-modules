# API management

# Create and configure the API management service

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "apim_subnet" {
  name                 = "${local.azurerm_subnet_name}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

data "null_data_source" "hostname_configurations" {
  count  = "${length(var.hostname_configurations)}"

  inputs = {
    type                       = "Proxy"
    hostName                   = "${lookup(var.hostname_configurations[count.index],"hostname_prefix")}.${var.environment}.io.italia.it"
    negotiateClientCertificate = "false"
    defaultSslBinding          = "true"
    keyVaultId                 = "https://${local.azurerm_key_vault_name}.vault.azure.net/secrets/generated-cert"
  }
}

# New infrastructure

module "azurerm_api_management" {
  source                 = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version            = "2019-01-01"
  type                   = "Microsoft.ApiManagement/service"
  name                   = "${local.azurerm_apim_name}"
  resource_group_name    = "${data.azurerm_resource_group.rg.name}"
  location               = "${var.location}"
  enable_output          = true

  random_deployment_name = true

  properties {
    publisherEmail              = "${var.publisher_email}"
    publisherName               = "${var.publisher_name}"
    virtualNetworkType          = "${var.virtualNetworkType}"

    virtualNetworkConfiguration = {
      subnetResourceId = "${data.azurerm_subnet.apim_subnet.id}"
    }

    hostnameConfigurations      = [
      {
        type                       = "Proxy"
        hostName                   = "${local.hostname_configurations_hostname}"
        negotiateClientCertificate = "false"
        defaultSslBinding          = "true"
        keyVaultId                 = "${local.hostname_configurations_keyvault_id}"
      }
    ]

    customProperties            = "${var.customProperties}"
  }

  sku {
    name     = "${var.sku_name}"
    capacity = "${var.sku_capacity}"
  }

  tags = {
    environment = "${var.environment}"
  }
}
