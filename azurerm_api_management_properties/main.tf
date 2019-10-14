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

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault_secret" "apim_secret_named_values" {
  count        = "${length(var.apim_secret_named_values)}"
  name         = "${lookup(var.apim_secret_named_values[count.index],"vault_alias")}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

# New infrastructure

resource "azurerm_api_management_property" "named_values" {
  count               = "${length(var.apim_named_values)}"
  name                = "${lookup(var.apim_named_values[count.index],"name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  display_name        = "${lookup(var.apim_named_values[count.index],"display_name","${lookup(var.apim_named_values[count.index],"name")}")}"
  value               = "${lookup(var.apim_named_values[count.index],"value","undefined")}"
  secret              = "false"
}

resource "azurerm_api_management_property" "secret_named_values" {
  count               = "${length(var.apim_secret_named_values)}"
  name                = "${lookup(var.apim_secret_named_values[count.index],"name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  display_name        = "${lookup(var.apim_secret_named_values[count.index],"display_name","${lookup(var.apim_secret_named_values[count.index],"name")}")}"
  value               = "${element(data.azurerm_key_vault_secret.apim_secret_named_values.*.value, count.index)}"
  secret              = "true"
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

resource "azurerm_api_management_user" "apim_users" {
  count               = "${length(var.apim_users)}"
  user_id             = "${lookup(var.apim_users[count.index],"user_id","---")}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"

  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  first_name = "${lookup(var.apim_users[count.index],"first_name","---")}"
  last_name  = "${lookup(var.apim_users[count.index],"last_name","---")}"
  email      = "${lookup(var.apim_users[count.index],"email","---")}"

  state = "active"
}
