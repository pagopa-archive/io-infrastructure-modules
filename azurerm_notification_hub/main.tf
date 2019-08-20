# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}
data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}
data "azurerm_key_vault_secret" "notification_hub_gcm_key" {
  name         = "nhub01gcmkey"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}
data "azurerm_key_vault_secret" "notification_hub_bundle_id" {
  name         = "nhub01bundleid"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}
data "azurerm_key_vault_secret" "notification_hub_key_id" {
  name         = "nhub01keyid"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}
data "azurerm_key_vault_secret" "notification_hub_team_id" {
  name         = "nhub01teamid"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}
data "azurerm_key_vault_secret" "notification_hub_token_id" {
  name         = "nhub01token"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}
# New infrastructure

resource "azurerm_notification_hub_namespace" "notification_hub_ns" {
  name                = "${local.azurerm_notification_hub_namespace_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  namespace_type      = "NotificationHub"

  sku_name = "${var.azurerm_notification_hub_namespace_sku_name}"
}

resource "azurerm_notification_hub" "notification_hub" {
  name                = "${local.azurerm_notification_hub_name}"
  namespace_name      = "${azurerm_notification_hub_namespace.notification_hub_ns.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  apns_credential {
    application_mode = "${var.azurerm_notification_hub_apns_credential_application_mode}"
    bundle_id        = "${data.azurerm_key_vault_secret.notification_hub_bundle_id.value}" # 
    key_id           = "${data.azurerm_key_vault_secret.notification_hub_key_id.value}"
    team_id          = "${data.azurerm_key_vault_secret.notification_hub_team_id.value}"
    token            = "${data.azurerm_key_vault_secret.notification_hub_token_id.value}"
  }

  gcm_credential {
    api_key = "${data.azurerm_key_vault_secret.notification_hub_gcm_key.value}"
  }
}
