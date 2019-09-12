# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_application_insights" "azurerm_application_insights" {
  count               = "${length(var.applications_insights)}"
  name                = "${var.resource_name_prefix}-${var.environment}-ai-${lookup(var.applications_insights[count.index], "azurerm_application_insights_name")}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  application_type    = "${lookup(var.applications_insights[count.index], "azurerm_application_insights_application_type")}"
}
