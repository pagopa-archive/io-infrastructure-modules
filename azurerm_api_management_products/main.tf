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

# New infrastructure

resource "azurerm_api_management_product" "products" {
  count                 = "${length(var.apim_products)}"
  product_id            = "${lookup(var.apim_products[count.index],"id")}"
  api_management_name   = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  display_name          = "${lookup(var.apim_products[count.index],"display_name","${lookup(var.apim_products[count.index],"id")}")}"
  description           = "${lookup(var.apim_products[count.index],"description","---")}"
  subscription_required = "${lookup(var.apim_products[count.index],"subscription_required","true")}"
  subscriptions_limit   = "${lookup(var.apim_products[count.index],"subscriptions_limit","100")}"
  approval_required     = "${lookup(var.apim_products[count.index],"approval_required","true")}"
  published             = "${lookup(var.apim_products[count.index],"published","true")}"
}

resource "azurerm_api_management_product_group" "product_groups" {
  count               = "${length(var.apim_products)}"
  product_id          = "${lookup(var.apim_products[count.index],"id")}"
  group_name          = "${lookup(var.apim_products[count.index],"admin_group","administrators")}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_api_management_product_policy" "product_policies" {
  count               = "${length(var.apim_products)}"
  product_id          = "${basename(element(azurerm_api_management_product.products.*.product_id,count.index))}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  xml_content         = "${lookup(var.apim_products[count.index],"xml_content","${local.api_management_default_product_policy}")}"
}

resource "azurerm_api_management_product_api" "apim_product_api_bindings" {
  count               = "${length(var.apim_product_api_bindings)}"
  api_name            = "${lookup(var.apim_product_api_bindings[count.index],"api_name")}"
  product_id          = "${element(azurerm_api_management_product.products.*.product_id, index(azurerm_api_management_product.products.*.product_id, lookup(var.apim_product_api_bindings[count.index],"product_id")))}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}
