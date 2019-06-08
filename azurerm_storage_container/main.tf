data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_storage_account" "sa" {
  name                = "${local.azurerm_storage_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.azurerm_storage_container_name}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  storage_account_name  = "${data.azurerm_storage_account.sa.name}"
  container_access_type = "${var.azurerm_storage_container_access_type}"
}
