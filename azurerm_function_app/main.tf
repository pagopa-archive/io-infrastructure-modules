# FUNCTIONS

resource "azurerm_function_app" "azurerm_function_app" {
  name                      = "${local.azurerm_functionapp_name}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  app_service_plan_id       = "${azurerm_app_service_plan.azurerm_app_service_plan.id}"
  storage_connection_string = "${azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"
  client_affinity_enabled   = false
  version                   = "~1"

  site_config = {
    # We don't want the express server to idle
    # so do not set `alwaysOn: false` in production
    always_on = true
  }

  enable_builtin_logging = false

  # Do not set "AzureWebJobsDashboard" to disable builtin logging
  # see https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring#disable-built-in-logging

  app_settings = "${var.app_settings}"

  # connection_string = ["${var.connection_string}"]

  connection_string = [
    {
      name  = "COSMOSDB_KEY"
      type  = "Custom"
      value = "${var.cosmosdb_key}"
    },
    {
      name  = "COSMOSDB_URI"
      type  = "Custom"
      value = "${var.cosmosdb_uri}"
    },
  ]
}

# Client ID of an application used in the API management portal authentication flow
data "azurerm_key_vault_secret" "dev_portal_client_id" {
  name         = "dev-portal-client-id-${var.environment}"
  key_vault_id = "${var.key_vault_id}"
}

# Client secret of the application used in the API management portal authentication flow
data "azurerm_key_vault_secret" "dev_portal_client_secret" {
  name         = "dev-portal-client-secret-${var.environment}"
  key_vault_id = "${var.key_vault_id}"
}

resource "null_resource" "azurerm_function_app_git" {
  triggers = {
    azurerm_functionapp_id = "${azurerm_function_app.azurerm_function_app.id}"

    # trigger recreation of this resource when the following variables change
    azurerm_functionapp_git_repo   = "${var.azurerm_functionapp_git_repo}"
    azurerm_functionapp_git_branch = "${var.azurerm_functionapp_git_branch}"

    # increment the following value when changing the provisioner script to
    # trigger the re-execution of the script
    # TODO: consider using the hash of the script content instead
    provisioner_version = "1"
  }

  provisioner "local-exec" {
    command = "${join(" ", list(
      "ts-node --files ${var.website_git_provisioner}",
      "--resource-group-name ${var.resource_group_name}",
      "--app-name ${azurerm_function_app.azurerm_function_app.name}",
      "--git-repo ${var.azurerm_functionapp_git_repo}",
      "--git-branch ${var.azurerm_functionapp_git_branch}"))
    }"

    environment = {
      ENVIRONMENT                     = "${var.environment}"
      TF_VAR_ADB2C_TENANT_ID          = "${var.ADB2C_TENANT_ID}"
      TF_VAR_DEV_PORTAL_CLIENT_ID     = "${data.azurerm_key_vault_secret.dev_portal_client_id.value}"
      TF_VAR_DEV_PORTAL_CLIENT_SECRET = "${data.azurerm_key_vault_secret.dev_portal_client_secret.value}"
    }
  }
}

# locals {
#   application_outbound_ips = "${var.azurerm_shared_address_space_cidr},${azurerm_function_app.azurerm_function_app.outbound_ip_addresses},${var.azurerm_azure_portal_ips}"
# }

## APP SERVICE PLAN

resource "azurerm_app_service_plan" "azurerm_app_service_plan" {
  name                = "${local.azurerm_app_service_plan_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  sku {
    tier = "Standard"

    # see https://azure.microsoft.com/en-en/pricing/details/app-service/
    size = "S1"
  }
}

# STORAGE ACCOUNT
resource "azurerm_storage_account" "azurerm_functionapp_storage_account" {
  name                = "${local.azurerm_functionapp_storage_account_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  # can be one between Premium_LRS, Standard_GRS, Standard_LRS, Standard_RAGRS, Standard_ZRS
  # see https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy
  account_tier = "Standard"

  account_replication_type = "${var.account_replication_type}"

  # account_replication_type = "GRS"

  # see https://docs.microsoft.com/en-us/azure/storage/common/storage-service-encryption
  enable_blob_encryption    = true
  enable_https_traffic_only = true

  # enable_file_encryption   = true

  tags {
    environment = "${var.environment}"
  }
}
