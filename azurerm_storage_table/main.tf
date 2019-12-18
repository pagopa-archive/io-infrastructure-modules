# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_storage_account" "sa" {
  name                = "${local.azurerm_storage_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_storage_table" "table" {
  name                 = "${var.azurerm_storage_table_name}"
  storage_account_name = "${data.azurerm_storage_account.sa.name}"
}
