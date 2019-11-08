# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_app_service_plan" "sp" {
  name                = "${local.azurerm_app_service_plan_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_storage_account" "azurerm_functionapp_storage_account" {
  name                = "${local.azurerm_storage_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault_secret" "functionapp_settings_secrets" {
  count        = "${length(var.functionapp_settings_secrets)}"
  name         = "${lookup(var.functionapp_settings_secrets[count.index],"vault_alias")}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

data "null_data_source" "functionapp_settings" {
  count = "${length(var.functionapp_settings)}"

  inputs = {
    Name  = "${lookup(var.functionapp_settings[count.index],"name")}"
    Value = "${lookup(var.functionapp_settings[count.index],"value")}"
  }
}

data "null_data_source" "functionapp_settings_secrets" {
  count = "${length(var.functionapp_settings_secrets)}"

  inputs = {
    Name  = "${lookup(var.functionapp_settings_secrets[count.index],"name")}"
    Value = "${element(data.azurerm_key_vault_secret.functionapp_settings_secrets.*.value, count.index)}"
  }
}

data "azurerm_key_vault_secret" "functionapp_connection_strings" {
  count        = "${length(var.functionapp_connection_strings)}"
  name         = "${lookup(var.functionapp_connection_strings[count.index],"vault_alias")}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

data "null_data_source" "functionapp_connection_strings" {
  count = "${length(var.functionapp_connection_strings)}"

  inputs = {
    name             = "${lookup(var.functionapp_connection_strings[count.index],"name")}"
    connectionstring = "${element(data.azurerm_key_vault_secret.functionapp_connection_strings.*.value, count.index)}"
    type             = "${var.functionapp_connection_strings_type}"
  }
}

# New infrastructure
module "azurerm_function_app_site" {
  name                = "${local.azurerm_functionapp_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2016-08-01"
  type                = "Microsoft.Web/sites"
  kind                = "functionapp"
  enable_output       = true

  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    enabled = "true"

    clientAffinityEnabled = "false"

    siteConfig = {
      alwaysOn = "true"

      connectionStrings = ["${data.null_data_source.functionapp_connection_strings.*.outputs}"]

      appSettings = [
        {
          Name  = "AzureWebJobsStorage"
          Value = "${data.azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"
        },
        "${data.null_data_source.functionapp_settings.*.outputs}",
        "${data.null_data_source.functionapp_settings_secrets.*.outputs}"
      ]
    }

    httpsOnly    = "${var.https_only}"
    serverFarmId = "${data.azurerm_app_service_plan.sp.id}"
  }
}
