# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_eventhub_namespace" "eventhub_ns" {
  name                = "${local.azurerm_eventhub_namespace_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  sku                 = "${var.azurerm_eventhub_namespace_sku}"
  capacity            = "${var.azurerm_eventhub_namespace_capacity}"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_eventhub" "eventhub" {
  name                = "${local.azurerm_eventhub_name}"
  namespace_name      = "${azurerm_eventhub_namespace.eventhub_ns.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  partition_count     = "${var.azurerm_eventhub_partition_count}"
  message_retention   = "${var.azurerm_eventhub_messege_retention}"
}

resource "azurerm_eventhub_authorization_rule" "eventhub_rule" {
  count               = "${length(var.azurerm_eventhub_authorization_rules)}"
  name                = "${var.resource_name_prefix}-${var.environment}-ehr-${lookup(var.azurerm_eventhub_authorization_rules[count.index], "listen")}"
  namespace_name      = "${azurerm_eventhub_namespace.eventhub_ns.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  eventhub_name       = "${azurerm_eventhub.eventhub.name}"
  listen              = "${lookup(var.azurerm_eventhub_authorization_rules[count.index], "listen")}"
  send                = "${lookup(var.azurerm_eventhub_authorization_rules[count.index], "send")}"
  manage              = "${lookup(var.azurerm_eventhub_authorization_rules[count.index], "manage")}"
}
