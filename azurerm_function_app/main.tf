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

data "azurerm_key_vault_secret" "appsettings" {
  count        = "${length(var.appSettings)}"
  name         = "${lookup(var.appSettings[count.index],"Alias")}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

data "null_data_source" "appSettings" {
  count = "${length(var.appSettings)}"

  inputs = {
    Name  = "${lookup(var.appSettings[count.index],"Name")}"
    Value = "${element(data.azurerm_key_vault_secret.appsettings.*.value, count.index)}"
  }
}

data "azurerm_key_vault_secret" "connectionStrings" {
  count        = "${length(var.connectionStrings)}"
  name         = "${lookup(var.connectionStrings[count.index],"Alias")}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

data "null_data_source" "connectionStrings" {
  count = "${length(var.connectionStrings)}"

  inputs = {
    Name  = "${lookup(var.connectionStrings[count.index],"Name")}"
    Value = "${element(data.azurerm_key_vault_secret.connectionStrings.*.value, count.index)}"
  }
}

# New infrastructure
module "azurerm_function_app_site" {
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2016-08-01"
  type                = "Microsoft.Web/sites"
  kind                = "functionapp"
  enable_output       = true
  name                = "${local.azurerm_functionapp_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    enabled = "true"

    clientAffinityEnabled = "false"

    siteConfig = {
      alwaysOn = "true"

      connectionStrings = ["${data.null_data_source.connectionStrings.*.outputs}"]

      appSettings = [
        {
          Name  = "AzureWebJobsStorage"
          Value = "${data.azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"
        },
        {
          Name  = "AzureWebJobsDashboard"
          Value = "${data.azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"
        },
        "${data.null_data_source.appSettings.*.outputs}",
      ]
    }

    httpsOnly    = "false"
    serverFarmId = "${data.azurerm_app_service_plan.sp.id}"
  }
}
