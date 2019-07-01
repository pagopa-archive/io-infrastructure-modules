# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_app_service_plan" "sp" {
  name                = "${local.azurerm_app_service_plan_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure
module "azurerm_function_app_site" {
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2016-08-01"
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
    enabled = "true"

    # app_service_plan_id   = "${data.azurerm_app_service_plan.sp.id}"
    clientAffinityEnabled = "false"

    # clientCertEnabled = "false"


    # containerSize = 1536


    # dailyMemoryTimeQuota = 0


    # hostNameSslStates = [{
    #   hostType = "Standard"


    #   name = "${local.azurerm_functionapp_name}.azurewebsites.net"


    #   sslState = "Disabled"
    # },
    #   {
    #     hostType = "Repository"


    #     name = "${local.azurerm_functionapp_name}.scm.azurewebsites.net"

    # sslState = "Disabled"
    #   },
    # ]
    siteConfig = {
      alwaysOn = "true"
    }
    # hostNamesDisabled  = "false"
    httpsOnly = "false"
    # reserved           = "false"
    # scmSiteAlsoStopped = "false"
    serverFarmId = "${data.azurerm_app_service_plan.sp.id}"
  }
}
