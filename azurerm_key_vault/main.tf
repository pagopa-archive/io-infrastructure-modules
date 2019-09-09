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

resource "azurerm_key_vault_access_policy" "user_access_policy" {
  count                   = "${length(var.user_policies)}"
  key_vault_id            = "${azurerm_key_vault.key_vault.id}"

  tenant_id               = "${var.azurerm_key_vault_tenant_id}"
  object_id               = "${lookup(var.user_policies[count.index], "object_id")}"
  key_permissions         = "${split(",",lookup(var.user_policies[count.index], "key_permissions"))}"
  secret_permissions      = "${split(",",lookup(var.user_policies[count.index], "secret_permissions"))}"
  certificate_permissions = "${split(",",lookup(var.user_policies[count.index], "certificate_permissions"))}"
}

resource "azurerm_key_vault_access_policy" "application_access_policy" {
  count                   = "${length(var.app_policies)}"
  key_vault_id            = "${azurerm_key_vault.key_vault.id}"

  tenant_id               = "${var.azurerm_key_vault_tenant_id}"
  object_id               = "${lookup(var.app_policies[count.index], "object_id")}"
  application_id          = "${lookup(var.app_policies[count.index], "application_id")}"
  key_permissions         = "${split(",",lookup(var.app_policies[count.index],"key_permissions"))}"
  secret_permissions      = "${split(",",lookup(var.app_policies[count.index],"secret_permissions"))}"
  certificate_permissions = "${split(",",lookup(var.app_policies[count.index],"certificate_permissions"))}"
}
