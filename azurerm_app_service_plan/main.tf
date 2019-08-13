# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${local.azurerm_app_service_plan_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  kind                = "${var.azurerm_app_service_plan_kind}"

  sku {
    tier     = "${var.azurerm_app_service_plan_sku_tier}"
    size     = "${var.azurerm_app_service_plan_sku_size}"
    capacity = "${var.azurerm_app_service_plan_sku_capacity}"
  }

  maximum_elastic_worker_count = "${var.azurerm_app_service_plan_maximum_elastic_worker_count}"
}
