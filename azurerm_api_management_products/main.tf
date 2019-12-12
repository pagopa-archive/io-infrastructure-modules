# API management

# Create and configure the API management service

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_api_management" "api_management" {
  name                = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "null_data_source" "apim_product_api_bindings" {
  count = "${length(var.apim_product_api_bindings)}"

  inputs = {
    api_name   = "${lookup(var.apim_product_api_bindings[count.index], "api_name")}"
    product_id = "${var.resource_name_prefix}-${var.environment}-apim-${lookup(var.apim_product_api_bindings[count.index], "product_id_suffix")}"
  }
}

# New infrastructure

resource "azurerm_api_management_product" "products" {
  count                 = "${length(var.apim_products)}"
  product_id            = "${var.resource_name_prefix}-${var.environment}-apim-${lookup(var.apim_products[count.index],"id_suffix")}"
  api_management_name   = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  display_name          = "${lookup(var.apim_products[count.index],"display_name","${var.resource_name_prefix}-${var.environment}-apim-${lookup(var.apim_products[count.index],"id_suffix")}")}"
  description           = "${lookup(var.apim_products[count.index],"description","---")}"
  subscription_required = "${lookup(var.apim_products[count.index],"subscription_required","true")}"
  subscriptions_limit   = "${lookup(var.apim_products[count.index],"subscriptions_limit","100")}"
  approval_required     = "${lookup(var.apim_products[count.index],"approval_required","true")}"
  published             = "${lookup(var.apim_products[count.index],"published","true")}"
}

resource "azurerm_api_management_product_group" "product_groups" {
  count               = "${length(var.apim_products)}"
  product_id          = "${var.resource_name_prefix}-${var.environment}-apim-${lookup(var.apim_products[count.index],"id_suffix")}"
  group_name          = "${lookup(var.apim_products[count.index],"admin_group","administrators")}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  depends_on          = [
    "azurerm_api_management_product.products"
  ]
}

resource "azurerm_api_management_product_policy" "product_policies" {
  count               = "${length(var.apim_products)}"
  product_id          = "${basename(element(azurerm_api_management_product.products.*.product_id,count.index))}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  xml_content         = "${lookup(var.apim_products[count.index],"xml_content","${local.api_management_default_product_policy}")}"
}

resource "azurerm_api_management_product_api" "apim_product_api_bindings" {
  count               = "${length(data.null_data_source.apim_product_api_bindings.*.outputs)}"
  api_name            = "${lookup(data.null_data_source.apim_product_api_bindings.*.outputs[count.index],"api_name")}"
  product_id          = "${element(azurerm_api_management_product.products.*.product_id, index(azurerm_api_management_product.products.*.product_id, lookup(data.null_data_source.apim_product_api_bindings.*.outputs[count.index],"product_id")))}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}
