# API management
## Create and configure the API management service
# Existing infrastructure
data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_app_service" "function" {
  name                = "${local.azurerm_function_app_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
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

module "azurerm_api_management_backendUrl" {
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2019-01-01"
  type                = "Microsoft.ApiManagement/service/properties"
  name                = "${local.azurerm_apim_name}/backendUrl"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  enable_output       = false

  random_deployment_name = true

  properties {
    tags = [
      "${var.environment}",
    ]

    secret      = "false"
    displayName = "backendUrl"
    value       = "${var.backendUrl}"
  }

  sku {
    name     = "${var.sku_name}"
    capacity = "${var.sku_capacity}"
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_api_management_group" "groups" {
  count               = "${length(var.apim_groups)}"
  name                = "${lookup(var.apim_groups[count.index],"name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  api_management_name = "${local.azurerm_apim_name}"
  display_name        = "${lookup(var.apim_groups[count.index],"display_name","${lookup(var.apim_groups[count.index],"name")}")}"
  description         = "${lookup(var.apim_groups[count.index],"description","---")}"
  type                = "${lookup(var.apim_groups[count.index],"type","custom")}"
}

resource "azurerm_api_management_product" "products" {
  product_id            = "${lookup(var.apim_products[count.index],"id")}"
  api_management_name   = "${local.azurerm_apim_name}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  display_name          = "${lookup(var.apim_products[count.index],"display_name","${lookup(var.apim_products[count.index],"id")}")}"
  subscription_required = "${lookup(var.apim_products[count.index],"subscription_required","true")}"
  subscriptions_limit   = "${lookup(var.apim_products[count.index],"subscriptions_limit","100")}"
  approval_required     = "${lookup(var.apim_products[count.index],"approval_required","true")}"
  published             = "${lookup(var.apim_products[count.index],"published","true")}"
}
