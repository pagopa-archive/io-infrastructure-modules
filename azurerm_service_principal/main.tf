data "azurerm_subscription" "current" {}

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azuread_application" "application_aad_server" {
  count = "${var.app_type == "k8s_aad_client" ? 1 : 0}"
  name  = "${local.azuread_application_name_k8s_aad_server}"
}

# New infrastructure

# Create an azurerm application
resource "azuread_application" "application" {
  count = "${var.app_type == "generic" ? 1 : 0}"
  name  = "${local.azuread_application_name}"
}

resource "azuread_application" "application_aad_server" {
  count                   = "${var.app_type == "k8s_aad_server" ? 1 : 0}"
  name                    = "${local.azuread_application_name}"
  group_membership_claims = "All"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a"
      type = "Scope"
    }

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }

    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }
  }

  app_role {
    allowed_member_types = [
      "Application"
    ]

    description  = "${local.azuread_application_name}"
    display_name = "${local.azuread_application_name}"
    is_enabled   = true
    value        = "Admin"
  }
}

resource "azuread_application" "application_aad_client" {
  count                   = "${var.app_type == "k8s_aad_client" ? 1 : 0}"
  name                    = "${local.azuread_application_name}"
  group_membership_claims = "All"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = "${data.azuread_application.application_aad_server.application_id}"

    resource_access {
      id   = "${data.azuread_application.application_aad_server.oauth2_permissions.0.id}"
      type = "Scope"
    }
  }
}

# Create a azurerm service principal
resource "azuread_service_principal" "service_principal" {
  count          = "${var.app_type == "generic" ? 1 : 0}"
  application_id = "${azuread_application.application.application_id}"
}

resource "azuread_service_principal" "service_principal_aad_server" {
  count          = "${var.app_type == "k8s_aad_server" ? 1 : 0}"
  application_id = "${azuread_application.application_aad_server.application_id}"
}

resource "azuread_service_principal" "service_principal_aad_client" {
  count          = "${var.app_type == "k8s_aad_client" ? 1 : 0}"
  application_id = "${azuread_application.application_aad_client.application_id}"
}

# Generate random password
resource "random_string" "service_principal_password_txt" {
  length           = 20
  special          = true
  override_special = "!@#$&*()-_=+[]{}<>:?"
}

# Set client secret
resource "azuread_service_principal_password" "service_principal_password" {
  count                = "${var.app_type == "generic" ? 1 : 0}"
  service_principal_id = "${azuread_service_principal.service_principal.id}"
  value                = "${random_string.service_principal_password_txt.result}"
  end_date_relative    = "8760h"

  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "azuread_service_principal_password" "service_principal_password_aad_server" {
  count                = "${var.app_type == "k8s_aad_server" ? 1 : 0}"
  service_principal_id = "${azuread_service_principal.service_principal_aad_server.id}"
  value                = "${random_string.service_principal_password_txt.result}"
  end_date_relative    = "8760h"

  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "azuread_service_principal_password" "service_principal_password_aad_client" {
  count                = "${var.app_type == "k8s_aad_client" ? 1 : 0}"
  service_principal_id = "${azuread_service_principal.service_principal_aad_client.id}"
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
  count                = "${var.app_type == "generic" ? 1 : 0}"
  scope                = "${data.azurerm_subscription.current.id}"
  role_definition_name = "${var.azurerm_role_assignment_role_definition_name}"
  principal_id         = "${azuread_service_principal.service_principal.id}"
}

resource "azurerm_role_assignment" "sp_role_aad_server" {
  count                = "${var.app_type == "k8s_aad_server" ? 1 : 0}"
  scope                = "${data.azurerm_subscription.current.id}"
  role_definition_name = "${var.azurerm_role_assignment_role_definition_name}"
  principal_id         = "${azuread_service_principal.service_principal_aad_server.id}"
}

resource "azurerm_role_assignment" "sp_role_aad_client" {
  count                = "${var.app_type == "k8s_aad_client" ? 1 : 0}"
  scope                = "${data.azurerm_subscription.current.id}"
  role_definition_name = "${var.azurerm_role_assignment_role_definition_name}"
  principal_id         = "${azuread_service_principal.service_principal_aad_client.id}"
}
