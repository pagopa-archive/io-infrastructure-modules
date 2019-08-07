# API management

# Create and configure the API management service

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_app_service" "function" {
  name                = "${local.azurerm_function_app_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_api_management" "api_management" {
  name                = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_api_management_property" "properties" {
  count               = "${length(var.apim_properties)}"
  name                = "${lookup(var.apim_properties[count.index],"name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  display_name        = "${lookup(var.apim_properties[count.index],"display_name","${lookup(var.apim_properties[count.index],"name")}")}"
  value               = "${lookup(var.apim_properties[count.index],"value","undefined")}"
  secret              = "${lookup(var.apim_properties[count.index],"secret","false")}"
}

resource "azurerm_api_management_group" "groups" {
  count               = "${length(var.apim_groups)}"
  name                = "${lookup(var.apim_groups[count.index],"name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  display_name        = "${lookup(var.apim_groups[count.index],"display_name","${lookup(var.apim_groups[count.index],"name")}")}"
  description         = "${lookup(var.apim_groups[count.index],"description","---")}"
  type                = "${lookup(var.apim_groups[count.index],"type","custom")}"
}
