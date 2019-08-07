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

# TODO: Subnet cannot be added to Vnet integration  
# Microsoft Support Request Number: 119062622001983
# Pivotal tracker link: https://www.pivotaltracker.com/story/show/167019950

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

module "azurerm_function_app_sourcecontrols" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2015-08-01"
  type        = "Microsoft.Web/sites/sourcecontrols"

  enable_output       = false
  name                = "${local.azurerm_functionapp_name}/web"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    RepoUrl             = "${var.azurerm_functionapp_git_repo}"
    branch              = "${var.azurerm_functionapp_git_branch}"
    IsManualIntegration = "true"
  }
}
