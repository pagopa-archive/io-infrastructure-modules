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
  enable_output       = false
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

    containerSize = 1536

    dailyMemoryTimeQuota = 0

    hostNameSslStates = [{
      hostType = "Standard"

      name = "${local.azurerm_functionapp_name}.azurewebsites.net"

      sslState = "Disabled"
    },
      {
        hostType = "Repository"

        name = "${local.azurerm_functionapp_name}.scm.azurewebsites.net"

        sslState = "Disabled"
      },
    ]

    hostNamesDisabled  = "false"
    httpsOnly          = "false"
    reserved           = "false"
    scmSiteAlsoStopped = "false"
    serverFarmId       = "${data.azurerm_app_service_plan.sp.id}"

    # siteConfig = {
    #   appSettings = [
    #     {
    #       "name" = "AzureWebJobsStorage"

    #       "value" = "DefaultEndpointsProtocol=https;AccountName=functionpremiumplantest;AccountKey=eatorUEm4DumJuylUw5F5zxQQ2fvMxLxg5nLqag5W9pvKimVZ+MCBhYJM8Mz3CCV30AmjJTrsvRaSOkkCdXO8g=="
    #     },
    #     {
    #       "name" = "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING"

    #       "value" = "DefaultEndpointsProtocol=https;AccountName=functionpremiumplantest;AccountKey=eatorUEm4DumJuylUw5F5zxQQ2fvMxLxg5nLqag5W9pvKimVZ+MCBhYJM8Mz3CCV30AmjJTrsvRaSOkkCdXO8g=="
    #     },
    #     {
    #       "name" = "WEBSITE_CONTENTSHARE"

    #       "value" = "[toLower(variables('functionAppName'))]"
    #     },
    #     {
    #       "name" = "FUNCTIONS_EXTENSION_VERSION"

    #       "value" = "~2"
    #     },
    #     {
    #       "name" = "WEBSITE_NODE_DEFAULT_VERSION"

    #       "value" = "10.14.1"
    #     },
    #     {
    #       "name" = "APPINSIGHTS_INSTRUMENTATIONKEY"

    #       "value" = "ad8878cf-7a60-4a0c-9bb2-bd7ba1f66276"
    #     },
    #     {
    #       "name" = "FUNCTIONS_WORKER_RUNTIME"

    #       "value" = "dotnet"
    #     },
    #   ]
    # }

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

# New infrastructure
module "azurerm_function_app_VirtualNetworkConnections" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2018-11-01"
  type        = "Microsoft.Web/sites/virtualNetworkConnections"

  enable_output       = false
  name                = "${local.azurerm_functionapp_name}/2b5eb170-e6aa-4f63-b924-9a72691c2ba4_io-dev-subnet-functions"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  # depends_on             = ["module.azurerm_function_app"]
  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    vnetResourceId = "${data.azurerm_subnet.functions_subnet.id}"

    # vnetResourceId = "${data.azurerm_virtual_network.vnet.id}"

    certThumbprint = ""
    certBlob       = ""
    # routes         = ""
    # resyncRequired = "false"
    # dnsServers = ""
    isSwift = "true"
  }
}

# {
#             "type": "Microsoft.Web/sites/virtualNetworkConnections",
#             "apiVersion": "2016-08-01",
#             "name": "[concat(parameters('sites_testfunctionpremium_name'), '/2b5eb170-e6aa-4f63-b924-9a72691c2ba4_io-dev-subnet-functions')]",
#             "location": "West Europe",
#             "dependsOn": [
#                 "[resourceId('Microsoft.Web/sites', parameters('sites_testfunctionpremium_name'))]"
#             ],
#             "properties": {
#                 "vnetResourceId": "[concat(parameters('virtualNetworks_io_dev_vnet_common_externalid'), '/subnets/io-dev-subnet-functions')]",
#                 "certThumbprint": null,
#                 "certBlob": null,
#                 "routes": null,
#                 "resyncRequired": false,
#                 "dnsServers": null,
#                 "isSwift": true
#             }
#         }

# New infrastructure
module "azurerm_function_app_config" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2018-11-01"
  type        = "Microsoft.Web/sites/config"

  # kind                = "functionapp"
  enable_output       = false
  name                = "${local.azurerm_functionapp_name}/web"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  # depends_on             = ["module.azurerm_function_app"]
  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    alwaysOn = "false"

    appCommandLine = ""

    autoHealEnabled = "false"

    cors = {
      allowedOrigins = ["https://functions.azure.com", "https://functions-staging.azure.com", "https://functions-next.azure.com"]

      supportCredentials = "false"
    }

    customAppPoolIdentityAdminState = "false"

    customAppPoolIdentityTenantState = "false"

    defaultDocuments = ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php"]

    detailedErrorLoggingEnabled = "false"

    experiments = {
      rampUpRules = []
    }

    ftpsState = "AllAllowed"

    http20Enabled = "false"

    httpLoggingEnabled = "false"

    linuxFxVersion = ""

    loadBalancing = "LeastRequests"

    localMySqlEnabled = "false"

    logsDirectorySizeLimit = 35

    managedPipelineMode = "Integrated"

    minTlsVersion = "1.2"

    netFrameworkVersion = "v4.0"

    nodeVersion = ""

    numberOfWorkers = 1

    phpVersion = "5.6"

    publishingUsername = "$$${local.azurerm_functionapp_name}"

    pythonVersion = ""

    remoteDebuggingEnabled = "false"

    remoteDebuggingVersion = "VS2017"

    requestTracingEnabled = "false"

    reservedInstanceCount = 1

    routingRules = []

    scmType = "None"

    siteAuthEnabled = "false"

    siteAuthSettings = {
      additionalLoginParams = ""

      allowedAudiences = ""

      allowedExternalRedirectUrls = ""

      clientId = ""

      clientSecret = ""

      clientSecretCertificateThumbprint = ""

      defaultProvider = ""

      enabled = ""

      facebookAppId = ""

      facebookAppSecret = ""

      facebookOAuthScopes = ""

      googleClientId = ""

      googleClientSecret = ""

      googleOAuthScopes = ""

      isAadAutoProvisioned = "false"

      issuer = ""

      microsoftAccountClientId = ""

      microsoftAccountClientSecret = ""

      microsoftAccountOAuthScopes = ""

      tokenStoreEnabled = ""

      twitterConsumerKey = ""

      twitterConsumerSecret = ""

      unauthenticatedClientAction = ""
    }

    use32BitWorkerProcess = "true"

    virtualApplications = {
      physicalPath = "site\\wwwroot"

      preloadEnabled = "false"

      virtualDirectories = ""

      virtualPath = "/"
    }

    # vnetName = "${data.azurerm_virtual_network.vnet.name} #2b5eb170-e6aa-4f63-b924-9a72691c2ba4_io-dev-subnet-functions"
    vnetName = "${data.azurerm_virtual_network.vnet.name}"

    webSocketsEnabled  = "false"
    winAuthAdminState  = 0
    winAuthTenantState = 0
  }
}

# {
#         "type": "Microsoft.Web/sites/config",
#         "apiVersion": "2016-08-01",
#         "name": "[concat(parameters('sites_testfunctionpremium_name'), '/web')]",
#         "location": "West Europe",
#         "dependsOn": [
#             "[resourceId('Microsoft.Web/sites', parameters('sites_testfunctionpremium_name'))]"
#         ],
#         "properties": {
#             "numberOfWorkers": 1,
#             "defaultDocuments": [
#                 "Default.htm",
#                 "Default.html",
#                 "Default.asp",
#                 "index.htm",
#                 "index.html",
#                 "iisstart.htm",
#                 "default.aspx",
#                 "index.php"
#             ],
#             "netFrameworkVersion": "v4.0",
#             "phpVersion": "5.6",
#             "pythonVersion": "",
#             "nodeVersion": "",
#             "linuxFxVersion": "",
#             "requestTracingEnabled": false,
#             "remoteDebuggingEnabled": false,
#             "remoteDebuggingVersion": "VS2017",
#             "httpLoggingEnabled": false,
#             "logsDirectorySizeLimit": 35,
#             "detailedErrorLoggingEnabled": false,
#             "publishingUsername": "$testfunctionpremium",
#             "scmType": "None",
#             "use32BitWorkerProcess": true,
#             "webSocketsEnabled": false,
#             "alwaysOn": false,
#             "appCommandLine": "",
#             "managedPipelineMode": "Integrated",
#             "virtualApplications": [
#                 {
#                     "virtualPath": "/",
#                     "physicalPath": "site\\wwwroot",
#                     "preloadEnabled": false,
#                     "virtualDirectories": null
#                 }
#             ],
#             "winAuthAdminState": 0,
#             "winAuthTenantState": 0,
#             "customAppPoolIdentityAdminState": false,
#             "customAppPoolIdentityTenantState": false,
#             "loadBalancing": "LeastRequests",
#             "routingRules": [],
#             "experiments": {
#                 "rampUpRules": []
#             },
#             "autoHealEnabled": false,
#             "vnetName": "2b5eb170-e6aa-4f63-b924-9a72691c2ba4_io-dev-subnet-functions",
#             "siteAuthEnabled": false,
#             "siteAuthSettings": {
#                 "enabled": null,
#                 "unauthenticatedClientAction": null,
#                 "tokenStoreEnabled": null,
#                 "allowedExternalRedirectUrls": null,
#                 "defaultProvider": null,
#                 "clientId": null,
#                 "clientSecret": null,
#                 "clientSecretCertificateThumbprint": null,
#                 "issuer": null,
#                 "allowedAudiences": null,
#                 "additionalLoginParams": null,
#                 "isAadAutoProvisioned": false,
#                 "googleClientId": null,
#                 "googleClientSecret": null,
#                 "googleOAuthScopes": null,
#                 "facebookAppId": null,
#                 "facebookAppSecret": null,
#                 "facebookOAuthScopes": null,
#                 "twitterConsumerKey": null,
#                 "twitterConsumerSecret": null,
#                 "microsoftAccountClientId": null,
#                 "microsoftAccountClientSecret": null,
#                 "microsoftAccountOAuthScopes": null
#             },
#             "cors": {
#                 "allowedOrigins": [
#                     "https://functions.azure.com",
#                     "https://functions-staging.azure.com",
#                     "https://functions-next.azure.com"
#                 ],
#                 "supportCredentials": false
#             },
#             "localMySqlEnabled": false,
#             "http20Enabled": false,
#             "minTlsVersion": "1.2",
#             "ftpsState": "AllAllowed",
#             "reservedInstanceCount": 1
#         }
#     },


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

