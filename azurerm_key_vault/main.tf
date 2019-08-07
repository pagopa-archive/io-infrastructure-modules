# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

resource "azurerm_key_vault" "key_vault" {
  name                      = "${local.azurerm_key_vault_name}"
  location                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name       = "${data.azurerm_resource_group.rg.name}"
  tenant_id                 = "${var.azurerm_key_vault_tenant_id}"
  sku_name                  = "standard"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  count                   = "${length(var.policy_object_list_map)}"
  key_vault_id            = "${azurerm_key_vault.key_vault.id}"

  tenant_id               = "${var.azurerm_key_vault_tenant_id}"
  object_id               = "${lookup(var.policy_object_list_map[count.index],"object_id")}"

  key_permissions         = "${split(",",lookup(var.policy_object_list_map[count.index],"key_permissions"))}"
  secret_permissions      = "${split(",",lookup(var.policy_object_list_map[count.index],"secret_permissions"))}"
  certificate_permissions = "${split(",",lookup(var.policy_object_list_map[count.index],"certificate_permissions"))}"
}
