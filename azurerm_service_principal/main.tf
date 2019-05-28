data "azurerm_subscription" "current" {}

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

# Create an azurerm application
resource "azuread_application" "application" {
  name = "${local.azuread_application_name}"
}

# Create a azurerm service principal
resource "azuread_service_principal" "service_principal" {
  application_id = "${azuread_application.application.application_id}"
}

# Generate random password
resource "random_string" "service_principal_password_txt" {
  length           = 20
  special          = true
  override_special = "!@#$&*()-_=+[]{}<>:?"
}

# Set client secret
resource "azuread_service_principal_password" "service_principal_password" {
  service_principal_id = "${azuread_service_principal.service_principal.id}"
  value                = "${random_string.service_principal_password_txt.result}"
  end_date_relative    = "8760h"

  lifecycle {
    ignore_changes = ["value"]
  }
}

# Save secret in vault
resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = "${var.azurerm_key_vault_secret_name}"
  value        = "${random_string.service_principal_password_txt.result}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"

  lifecycle {
    ignore_changes = ["value"]
  }
}

# Assign role to service principal
resource "azurerm_role_assignment" "sp_role" {
  scope                = "${data.azurerm_subscription.current.id}"
  role_definition_name = "${var.azurerm_role_assignment_role_definition_name}"
  principal_id         = "${azuread_service_principal.service_principal.id}"
}
