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

data "azurerm_app_service_plan" "sp" {
  name                = "${local.azurerm_app_service_plan_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

module "azurerm_function_app_settings" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2016-08-01"
  type        = "Microsoft.Web/sites/config"

  # kind                = "functionapp"
  enable_output       = false
  name                = "${local.azurerm_functionapp_name}/appsettings"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    AzureWebJobsStorage = "${data.azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"

    AzureWebJobsDashboard        = "${data.azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"
    FUNCTIONS_EXTENSION_VERSION  = "${var.functions_extension_version}"
    WEBSITE_NODE_DEFAULT_VERSION = "${var.website_node_default_version}"
    FUNCTIONS_WORKER_RUNTIME     = "${var.functions_worker_runtime}"

    # WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = "${data.azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"

    # WEBSITE_CONTENTSHARE = "${local.azurerm_functionapp_name}"

    #   },

    #   {
    #     "name" = "APPINSIGHTS_INSTRUMENTATIONKEY"

    #     "value" = "ad8878cf-7a60-4a0c-9bb2-bd7ba1f66276"
    #   },
  }
}

# module "azurerm_function_app_web" {
#   source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
#   api_version = "2016-08-01"
#   type        = "Microsoft.Web/sites/config"

#   enable_output       = false
#   name                = "${local.azurerm_functionapp_name}/web"
#   resource_group_name = "${data.azurerm_resource_group.rg.name}"
#   location            = "${data.azurerm_resource_group.rg.location}"

#   random_deployment_name = true

#   tags = {
#     environment = "${var.environment}"
#   }

#   properties {
#     vnetName = "${data.azurerm_virtual_network.vnet.name}"
#   }
# }

module "azurerm_function_app_VirtualNetwork" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2018-02-01"
  type        = "Microsoft.Web/sites/config"

  enable_output = false

  # name                   = "${local.azurerm_functionapp_name}/virtualNetwork"
  name                   = "${local.azurerm_functionapp_name}/${data.azurerm_virtual_network.vnet.name}"
  resource_group_name    = "${data.azurerm_resource_group.rg.name}"
  location               = "${data.azurerm_resource_group.rg.location}"
  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    subnetResourceId = "${data.azurerm_subnet.functions_subnet.id}"
    swiftSupported   = "true"
  }
}

module "azurerm_function_app_VirtualNetworkConnections" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2015-08-01"
  type        = "Microsoft.Web/sites/virtualNetworkConnections"

  enable_output       = false
  name                = "${local.azurerm_functionapp_name}/${data.azurerm_virtual_network.vnet.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    vnetResourceId = "${data.azurerm_virtual_network.vnet.id}"

    # certThumbprint = ""
    # certBlob       = ""
    # routes         = ""
    # resyncRequired = "false"
    # dnsServers = ""
    isSwift = "true"
  }
}

# resource "null_resource" "azurerm_function_app_git" {
#   triggers = {
#     azurerm_functionapp_name = "${local.azurerm_functionapp_name}"

#     # trigger recreation of this resource when the following variables change
#     azurerm_functionapp_git_repo   = "${var.azurerm_functionapp_git_repo}"
#     azurerm_functionapp_git_branch = "${var.azurerm_functionapp_git_branch}"

#     # increment the following value when changing the provisioner script to
#     # trigger the re-execution of the script
#     # TODO: consider using the hash of the script content instead
#     provisioner_version = "1"
#   }

#   provisioner "local-exec" {
#     command = "${join(" ", list(
#       "az functionapp deployment source config --branch ${var.azurerm_functionapp_git_branch}",
#       " --manual-integration",
#       " --name  ${local.azurerm_functionapp_name}",
#       " --repo-url ${var.azurerm_functionapp_git_repo}",
#       " --resource-group ${data.azurerm_resource_group.rg.name}"))}"

#     # "${join(" ", list(
#     #   "ts-node ${var.website_git_provisioner}",
#     #   "--resource-group-name ${data.azurerm_resource_group.rg.name}",
#     #   "--app-name ${local.azurerm_functionapp_name}",
#     #   "--git-repo ${var.azurerm_functionapp_git_repo}",
#     #   "--git-branch ${var.azurerm_functionapp_git_branch}"))
#     # }"

#     environment = {
#       # ENVIRONMENT                     = "${var.environment}"
#       TF_VAR_ADB2C_TENANT_ID          = "${var.azurerm_key_vault_tenant_id}"
#       TF_VAR_DEV_PORTAL_CLIENT_ID     = "${data.azurerm_key_vault_secret.dev_portal_client_id.value}"
#       TF_VAR_DEV_PORTAL_CLIENT_SECRET = "${data.azurerm_key_vault_secret.dev_portal_client_secret.value}"
#     }
#   }
# }

module "azurerm_function_app_sourcecontrols" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2015-08-01"
  type        = "Microsoft.Web/sites/sourcecontrols"

  enable_output       = false
  name                = "${local.azurerm_functionapp_name}/web"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    RepoUrl             = "${var.azurerm_functionapp_git_repo}"
    branch              = "${var.azurerm_functionapp_git_branch}"
    IsManualIntegration = "true"
  }
}

#  "resources": [
#         {
#           "apiVersion": "2015-08-01",
#           "name": "web",
#           "type": "sourcecontrols",
#           "dependsOn": [
#             "[resourceId('Microsoft.Web/Sites', variables('functionAppName'))]"
#           ],
#           "properties": {
#             "RepoUrl": "[parameters('repoURL')]",
#             "branch": "[parameters('branch')]",
#             "IsManualIntegration": true
#           }

