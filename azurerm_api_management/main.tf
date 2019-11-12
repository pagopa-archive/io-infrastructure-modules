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

# New infrastructure

module "azurerm_api_management" {
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2019-01-01"
  type                = "Microsoft.ApiManagement/service"
  name                = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  enable_output       = true

  random_deployment_name = true

  properties {
    publisherEmail     = "${var.publisher_email}"
    publisherName      = "${var.publisher_name}"
    virtualNetworkType = "${var.virtualNetworkType}"

    virtualNetworkConfiguration = {
      subnetResourceId = "${data.azurerm_subnet.apim_subnet.id}"
    }

    hostnameConfigurations = "${var.hostnameConfigurations}"

    customProperties = "${var.customProperties}"
  }

  sku {
    name     = "${var.sku_name}"
    capacity = "${var.sku_capacity}"
  }

  tags = {
    environment = "${var.environment}"
  }
}
