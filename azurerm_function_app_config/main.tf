# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "functions_subnet" {
  name                 = "${local.azurerm_subnet_name}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

module "azurerm_function_app_site_web" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2016-08-01"
  type        = "Microsoft.Web/sites/config"

  enable_output = false

  name = "${local.azurerm_functionapp_name}/web"

  resource_group_name    = "${data.azurerm_resource_group.rg.name}"
  location               = "${data.azurerm_resource_group.rg.location}"
  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    reservedInstanceCount = "${var.azurerm_functionapp_reservedInstanceCount}"
  }
}
module "azurerm_function_app_VirtualNetwork" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2018-02-01"
  type        = "Microsoft.Web/sites/config"

  enable_output = false

  name = "${local.azurerm_functionapp_name}/virtualNetwork"

  resource_group_name    = "${data.azurerm_resource_group.rg.name}"
  location               = "${data.azurerm_resource_group.rg.location}"
  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    subnetResourceId = "${data.azurerm_subnet.functions_subnet.id}"
    swiftSupported   = "true"
  }
}
