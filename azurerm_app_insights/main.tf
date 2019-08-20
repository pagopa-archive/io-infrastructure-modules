# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_application_insights" "azurerm_application_insights" {
  name                = "${local.azurerm_application_insights_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  application_type    = "${var.azurerm_application_insights_application_type}"
}
