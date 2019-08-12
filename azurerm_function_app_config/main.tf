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

module "azurerm_function_app_site_web" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2016-08-01"
  type        = "Microsoft.Web/sites/config"

  enable_output = false

  name = "${local.azurerm_functionapp_name}/web"

  resource_group_name    = "${data.azurerm_resource_group.rg.name}"
  location               = "${data.azurerm_resource_group.rg.location}"
  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    reservedInstanceCount = "${var.azurerm_functionapp_reservedInstanceCount}"
  }
}

# "reservedInstanceCount": 2,
#   {
#             "type": "Microsoft.Web/sites/config",
#             "apiVersion": "2016-08-01",
#             "name": "[concat(parameters('sites_io_dev_fn_1_01_name'), '/web')]",
#             "location": "West Europe",
#             "dependsOn": [
#                 "[resourceId('Microsoft.Web/sites', parameters('sites_io_dev_fn_1_01_name'))]"
#             ],
#             "tags": {
#                 "environment": "dev"
#             },
#             "properties": {
#                 "numberOfWorkers": 1,
#                 "defaultDocuments": [
#                     "Default.htm",
#                     "Default.html",
#                     "Default.asp",
#                     "index.htm",
#                     "index.html",
#                     "iisstart.htm",
#                     "default.aspx",
#                     "index.php"
#                 ],
#                 "netFrameworkVersion": "v4.0",
#                 "phpVersion": "5.6",
#                 "pythonVersion": "",
#                 "nodeVersion": "",
#                 "linuxFxVersion": "",
#                 "requestTracingEnabled": false,
#                 "remoteDebuggingEnabled": false,
#                 "httpLoggingEnabled": false,
#                 "logsDirectorySizeLimit": 35,
#                 "detailedErrorLoggingEnabled": false,
#                 "publishingUsername": "$io-dev-fn-1-01",
#                 "scmType": "ExternalGit",
#                 "use32BitWorkerProcess": true,
#                 "webSocketsEnabled": false,
#                 "alwaysOn": true,
#                 "appCommandLine": "",
#                 "managedPipelineMode": "Integrated",
#                 "virtualApplications": [
#                     {
#                         "virtualPath": "/",
#                         "physicalPath": "site\\wwwroot",
#                         "preloadEnabled": true,
#                         "virtualDirectories": null
#                     }
#                 ],
#                 "winAuthAdminState": 0,
#                 "winAuthTenantState": 0,
#                 "customAppPoolIdentityAdminState": false,
#                 "customAppPoolIdentityTenantState": false,
#                 "loadBalancing": "LeastRequests",
#                 "routingRules": [],
#                 "experiments": {
#                     "rampUpRules": []
#                 },
#                 "autoHealEnabled": false,
#                 "vnetName": "2b5eb170-e6aa-4f63-b924-9a72691c2ba4_io-dev-subnet-functions",
#                 "siteAuthEnabled": false,
#                 "siteAuthSettings": {
#                     "enabled": null,
#                     "unauthenticatedClientAction": null,
#                     "tokenStoreEnabled": null,
#                     "allowedExternalRedirectUrls": null,
#                     "defaultProvider": null,
#                     "clientId": null,
#                     "clientSecret": null,
#                     "clientSecretCertificateThumbprint": null,
#                     "issuer": null,
#                     "allowedAudiences": null,
#                     "additionalLoginParams": null,
#                     "isAadAutoProvisioned": false,
#                     "googleClientId": null,
#                     "googleClientSecret": null,
#                     "googleOAuthScopes": null,
#                     "facebookAppId": null,
#                     "facebookAppSecret": null,
#                     "facebookOAuthScopes": null,
#                     "twitterConsumerKey": null,
#                     "twitterConsumerSecret": null,
#                     "microsoftAccountClientId": null,
#                     "microsoftAccountClientSecret": null,
#                     "microsoftAccountOAuthScopes": null
#                 },
#                 "cors": {
#                     "allowedOrigins": [
#                         "https://functions.azure.com",
#                         "https://functions-staging.azure.com",
#                         "https://functions-next.azure.com"
#                     ],
#                     "supportCredentials": false
#                 },
#                 "localMySqlEnabled": false,
#                 "http20Enabled": false,
#                 "minTlsVersion": "1.2",
#                 "ftpsState": "AllAllowed",
#                 "reservedInstanceCount": 2,
#                 "fileChangeAuditEnabled": false
#             }

module "azurerm_function_app_VirtualNetwork" {
  source      = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version = "2018-02-01"
  type        = "Microsoft.Web/sites/config"

  enable_output = false

  name = "${local.azurerm_functionapp_name}/virtualNetwork"

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
