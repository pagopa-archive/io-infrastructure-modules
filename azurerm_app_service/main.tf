data "azurerm_resource_group" "rg" {
    name = "${local.azurerm_resource_group_name}"
}
data "azurerm_app_service_plan" "plan" {
    name                = "${local.azurerm_service_plan_name}"
    resource_group_name = "${data.azurerm_resource_group.rg.name}"
}
data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
    name                = "${local.azurerm_log_analytics_workspace_name}"
    resource_group_name = "${local.azurerm_resource_group_name_main}"
}
data "azurerm_monitor_diagnostic_categories" "diag" {
    resource_id = "${azurerm_app_service.app_service.id}"
}
data "azurerm_virtual_network" "vnet" {
    count               = "${var.ip_restriction}"
    name                = "${local.azurerm_virtual_network_name}"
    resource_group_name = "${local.azurerm_resource_group_name_main}"
}
data "azurerm_subnet" "subnet" {
    count                = "${var.ip_restriction}"  
    name                 = "${local.azurerm_subnet_name}"
    virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
    resource_group_name  = "${local.azurerm_resource_group_name_main}"
}
data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${local.azurerm_resource_group_name_main}"
}

// Secrets from live
data "azurerm_key_vault_secret" "app_service_settings_secrets" {
  count        = "${length(var.app_service_settings_secrets)}"
  name         = "${lookup(var.app_service_settings_secrets[count.index],"vault_alias")}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

data "null_data_source" "app_service_settings_secrets" {
  count = "${length(var.app_service_settings_secrets)}"

  inputs = {
    key   = "${lookup(var.app_service_settings_secrets[count.index],"name")}"
    value = "${element(data.azurerm_key_vault_secret.app_service_settings_secrets.*.value, count.index)}"
  }
}
resource "azurerm_app_service" "app_service" {
    count               = "${1 - var.ip_restriction}"
    name                = "${local.azurerm_app_name}"
    resource_group_name = "${data.azurerm_resource_group.rg.name}"
    location            = "${data.azurerm_resource_group.rg.location}"
    app_service_plan_id = "${data.azurerm_app_service_plan.plan.id}"

    site_config {
        linux_fx_version = "${var.docker_image}"
        app_command_line = ""
    }

    app_settings = "${merge(var.app_service_settings, local.app_settings_secret_map)}"

    lifecycle {
        ignore_changes = [
        "site_config.0.linux_fx_version", # deployments are made outside of Terraform
        ]
    } 
}
resource "azurerm_app_service" "app_service_restriction" {
    count               = "${var.ip_restriction}"
    name                = "${local.azurerm_app_name}"
    resource_group_name = "${data.azurerm_resource_group.rg.name}"
    location            = "${data.azurerm_resource_group.rg.location}"
    app_service_plan_id = "${data.azurerm_app_service_plan.plan.id}"

    site_config = {
        linux_fx_version = "${var.docker_image}"
        app_command_line = ""

        ip_restriction = {
            virtual_network_subnet_id = "${data.azurerm_subnet.subnet.id}"
        }
    }

    app_settings = "${merge(var.app_service_settings, local.app_settings_secret_map)}"

    lifecycle {
        ignore_changes = [
        "site_config.0.linux_fx_version", # deployments are made outside of Terraform
        ]
    } 
}
// Add Azure Monitor Diagnostic
resource "azurerm_monitor_diagnostic_setting" "diag" {
  count                      = "${1 - var.ip_restriction}"
  name                       = "${local.azurerm_app_service_diagnostic_name}"
  target_resource_id         = "${azurerm_app_service.app_service.id}"
  log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.log_analytics_workspace.id}"

  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[0]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[1]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[2]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[3]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[4]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  metric {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.metrics[0]}"

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
}
resource "azurerm_monitor_diagnostic_setting" "diag_restriction" {
  count                      = "${var.ip_restriction}"
  name                       = "${local.azurerm_app_service_diagnostic_name}"
  target_resource_id         = "${azurerm_app_service.app_service_restriction.id}"
  log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.log_analytics_workspace.id}"

  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[0]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[1]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[2]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[3]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  log {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.logs[4]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
  metric {
    category = "${data.azurerm_monitor_diagnostic_categories.diag.metrics[0]}"

    retention_policy {
      enabled = true
      days    = "${var.app_service_diagnostic_logs_retention}"
    }
  }
}
