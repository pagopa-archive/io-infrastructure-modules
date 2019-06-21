# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "functions_subnet" {
  name                 = "${local.azurerm_subnet_name}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_storage_account" "azurerm_functionapp_storage_account" {
  name                = "${local.azurerm_storage_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# # Client ID of an application used in the API management portal authentication flow
# data "azurerm_key_vault_secret" "dev_portal_client_id" {
#   name         = "dev-portal-client-id-${var.environment}"
#   key_vault_id = "${var.key_vault_id}"
# }

# Client secret of the application used in the API management portal authentication flow
# data "azurerm_key_vault_secret" "dev_portal_client_secret" {
#   name         = "dev-portal-client-secret-${var.environment}"
#   key_vault_id = "${var.key_vault_id}"
# }

data "azurerm_app_service_plan" "sp" {
  name                = "${local.azurerm_app_service_plan_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure
module "azurerm_function_app" {
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2018-11-01"
  type                = "Microsoft.Web/sites"
  kind                = "functionapp"
  enable_output       = "false"
  name                = "${local.azurerm_functionapp_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    enabled               = "true"
    app_service_plan_id   = "${data.azurerm_app_service_plan.sp.id}"
    clientAffinityEnabled = "false"

    clientCertEnabled = "false"

    # "containerSize" = 1536


    # "dailyMemoryTimeQuota" = 0

    hostNameSslStates = {
      hostType = "Standard"

      name = "${local.azurerm_functionapp_name}.azurewebsites.net')]"

      sslState = "Disabled"
    }
    hostNameSslStates = {
      hostType = "Repository"

      name = "${local.azurerm_functionapp_name}.scm.azurewebsites.net')]"

      sslState = "Disabled"
    }
    hostNamesDisabled  = "false"
    httpsOnly          = "false"
    reserved           = "false"
    scmSiteAlsoStopped = "false"
    serverFarmId       = "${data.azurerm_app_service_plan.sp.id}"

    # storage_connection_string = "${data.azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"
    # client_affinity_enabled   = "false"
    # version                   = "~2"

    # site_config = {
    #   # We don't want the express server to idle so we do not
    #   # set `alwaysOn: "false"` in production
    #   always_on = true
    # }

    # enable_builtin_logging = "false"

    # # Do not set "AzureWebJobsDashboard" to disable builtin logging.
    # # See https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring#disable-built-in-logging

    # app_settings = "${var.app_settings}"
    # connection_string = [
    #   {
    #     name  = "COSMOSDB_KEY"
    #     type  = "Custom"
    #     value = "${var.cosmosdb_key}"
    #   },
    #   {
    #     name  = "COSMOSDB_URI"
    #     type  = "Custom"
    #     value = "${var.cosmosdb_uri}"
    #   },
    # ]
  }
}

# resource "azurerm_function_app" "azurerm_function_app" {
#   name                      = "${local.azurerm_functionapp_name}"
#   location                  = "${var.location}"
#   resource_group_name       = "${d.name}"
#   app_service_plan_id       = "${var.azurerm_app_service_plan_id}"
#   storage_connection_string = "${data.azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"
#   client_affinity_enabled   = "false"
#   version                   = "~2"


#   site_config = {
#     # We don't want the express server to idle so we do not
#     # set `alwaysOn: "false"` in production
#     always_on = true
#   }


#   enable_builtin_logging = "false"


#   # Do not set "AzureWebJobsDashboard" to disable builtin logging.
#   # See https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring#disable-built-in-logging


#   app_settings = "${var.app_settings}"
#   connection_string = [
#     {
#       name  = "COSMOSDB_KEY"
#       type  = "Custom"
#       value = "${var.cosmosdb_key}"
#     },
#     {
#       name  = "COSMOSDB_URI"
#       type  = "Custom"
#       value = "${var.cosmosdb_uri}"
#     },
#   ]
#   tags = {
#     environment = "${var.environment}"
#   }
# }


# resource "null_resource" "azurerm_function_app_git" {
#   triggers = {
#     azurerm_functionapp_id = "${azurerm_function_app.azurerm_function_app.id}"


#     # trigger recreation of this resource when the following variables change
#     azurerm_functionapp_git_repo   = "${var.azurerm_functionapp_git_repo}"
#     azurerm_functionapp_git_branch = "${var.azurerm_functionapp_git_branch}"


#     # Increment the following value when the provisioner script is
#     # changed to trigger the re-execution of the script.
#     # TODO: consider using the hash of the script content instead
#     provisioner_version = "1"
#   }


#   provisioner "local-exec" {
#     command = "${join(" ", list(
#       "ts-node --files ${var.website_git_provisioner}",
#       "--resource-group-name ${var.resource_group_name}",
#       "--app-name ${azurerm_function_app.azurerm_function_app.name}",
#       "--git-repo ${var.azurerm_functionapp_git_repo}",
#       "--git-branch ${var.azurerm_functionapp_git_branch}"))
#     }"


#     environment = {
#       ENVIRONMENT                     = "${var.environment}"
#       TF_VAR_ADB2C_TENANT_ID          = "${var.adb2c_tenant_id}"
#       TF_VAR_DEV_PORTAL_CLIENT_ID     = "${data.azurerm_key_vault_secret.dev_portal_client_id.value}"
#       TF_VAR_DEV_PORTAL_CLIENT_SECRET = "${data.azurerm_key_vault_secret.dev_portal_client_secret.value}"
#     }
#   }
# }


# resource "azurerm_app_service_plan" "azurerm_app_service_plan" {
#   name                = "${local.azurerm_app_service_plan_name}"
#   resource_group_name = "${var.resource_group_name}"
#   location            = "${var.location}"


#   sku {
#     tier = "Standard"


#     # See https://azure.microsoft.com/en-en/pricing/details/app-service/
#     size = "S1"
#   }
# }

