# API management
## Create and configure the API management service
# Existing infrastructure
data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_app_service" "function" {
  name                = "${local.azurerm_function_app_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "apim_subnet" {
  name                 = "${local.azurerm_subnet_name}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

# # Client ID of an application used in the API management portal authentication flow
# data "azurerm_key_vault_secret" "dev_portal_client_id" {
#   name         = "dev-portal-client-id-${var.environment}"
#   key_vault_id = "${var.key_vault_id}"
# }

# # Client secret of the application used in the API management portal authentication flow
# data "azurerm_key_vault_secret" "dev_portal_client_secret" {
#   name         = "dev-portal-client-secret-${var.environment}"
#   key_vault_id = "${var.key_vault_id}"
# }

module "azurerm_api_management" {
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2019-01-01"
  type                = "Microsoft.ApiManagement/service"
  name                = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  enable_output       = false

  random_deployment_name = true

  properties {
    publisherEmail     = "${var.publisher_email}"
    publisherName      = "${var.publisher_name}"
    virtualNetworkType = "${var.virtualNetworkType}"

    virtualNetworkConfiguration = {
      subnetResourceId = "${data.azurerm_subnet.apim_subnet.id}"
    }

    customProperties = "${var.customProperties}"
  }

  sku {
    name     = "${var.sku_name}"
    capacity = "${var.sku_capacity}"
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "null_resource" "azurerm_apim" {
  count = "${var.create ? 1 : 0}"

  triggers = {
    azurerm_function_app_name = "${local.azurerm_function_app_name}"

    provisioner_version = "${var.provisioner_version}"
  }

  provisioner "local-exec" {
    command = "${join(" ", list(
      "ts-node --files ${var.apim_provisioner}",
      "--environment ${var.environment}",
      "--azurerm_resource_group ${data.azurerm_resource_group.rg.name}",
      "--azurerm_apim ${local.azurerm_apim_name}",
      "--azurerm_apim_scm_url https://${local.azurerm_apim_name}.scm.azure-api.net/",
      "--azurerm_functionapp ${data.azurerm_app_service.function.name}",
      "--apim_configuration_path ${var.apim_configuration_path}"))
    }"

    environment = {
      ENVIRONMENT = "${var.environment}"

      # TF_VAR_ADB2C_TENANT_ID = "${var.ADB2C_TENANT_ID}"

      # TF_VAR_DEV_PORTAL_CLIENT_ID     = "${data.azurerm_key_vault_secret.dev_portal_client_id.value}"
      # TF_VAR_DEV_PORTAL_CLIENT_SECRET = "${data.azurerm_key_vault_secret.dev_portal_client_secret.value}"
    }
  }
}
