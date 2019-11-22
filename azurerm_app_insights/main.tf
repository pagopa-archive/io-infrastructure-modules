# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}
data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_application_insights" "azurerm_application_insights" {
  count               = "${length(var.applications_insights)}"
  name                = "${var.resource_name_prefix}-${var.environment}-ai-${lookup(var.applications_insights[count.index], "azurerm_application_insights_name")}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  application_type    = "${lookup(var.applications_insights[count.index], "azurerm_application_insights_application_type")}"
}

resource "azurerm_key_vault_secret" "azurerm_application_insights" {
  name         = "${var.azurerm_application_insights_instrumentation_key}"
  value        = "${azurerm_application_insights.azurerm_application_insights.instrumentation_key}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"

  lifecycle {
    ignore_changes = ["value"]
  }
}
