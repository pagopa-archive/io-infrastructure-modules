# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure
resource "azurerm_key_vault_certificate" "certificate" {
  name         = "generated-cert"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"

  certificate_policy {
    issuer_parameters {
      name = "${var.azurerm_key_vault_certificate_certificate_policy_issuer_parameters_name}"
    }

    key_properties {
      exportable = "${var.azurerm_key_vault_certificate_certificate_policy_key_properties_exportable}"
      key_size   = "${var.azurerm_key_vault_certificate_certificate_policy_key_properties_size}"
      key_type   = "${var.azurerm_key_vault_certificate_certificate_policy_key_properties_key_type}"
      reuse_key  = "${var.azurerm_key_vault_certificate_certificate_policy_key_properties_reuse_key}"
    }

    lifetime_action {
      action {
        action_type = "${var.azurerm_key_vault_certificate_certificate_policy_lifetime_action_action_action_type}"
      }

      trigger {
        days_before_expiry = "${var.azurerm_key_vault_certificate_certificate_policy_lifetime_action_trigger_days_before_expiry}"
      }
    }

    secret_properties {
      content_type = "${var.azurerm_key_vault_certificate_certificate_policy_secret_properties_content_type}"
    }

    x509_certificate_properties {
      extended_key_usage = ["${var.azurerm_key_vault_certificate_certificate_policy_x509_certificate_properties}"]
      key_usage          = ["${var.azurerm_key_vault_certificate_certificate_policy_key_usage}"]
      subject            = "${var.azurerm_key_vault_certificate_certificate_policy_x509_certificate_properties_subject}"
      validity_in_months = "${var.azurerm_key_vault_certificate_certificate_policy__x509_certificate_properties_validity_in_months}"
    }
  }
}
