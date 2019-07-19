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

module "azurerm_api_management" {
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2019-01-01"
  type                = "Microsoft.ApiManagement/service"
  name                = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  enable_output       = true

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

resource "azurerm_api_management_property" "properties" {
  count               = "${length(var.apim_properties)}"
  name                = "${lookup(var.apim_properties[count.index],"name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  api_management_name = "${local.azurerm_apim_name}"
  display_name        = "${lookup(var.apim_properties[count.index],"display_name","${lookup(var.apim_properties[count.index],"name")}")}"
  value               = "${lookup(var.apim_properties[count.index],"value","undefined")}"
  secret              = "${lookup(var.apim_properties[count.index],"secret","false")}"
}

resource "azurerm_api_management_group" "groups" {
  count               = "${length(var.apim_groups)}"
  name                = "${lookup(var.apim_groups[count.index],"name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  api_management_name = "${local.azurerm_apim_name}"
  display_name        = "${lookup(var.apim_groups[count.index],"display_name","${lookup(var.apim_groups[count.index],"name")}")}"
  description         = "${lookup(var.apim_groups[count.index],"description","---")}"
  type                = "${lookup(var.apim_groups[count.index],"type","custom")}"
}

resource "azurerm_api_management_product" "products" {
  count                 = "${length(var.apim_products)}"
  product_id            = "${lookup(var.apim_products[count.index],"id")}"
  api_management_name   = "${local.azurerm_apim_name}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  display_name          = "${lookup(var.apim_products[count.index],"display_name","${lookup(var.apim_products[count.index],"id")}")}"
  description           = "${lookup(var.apim_products[count.index],"description","---")}"
  subscription_required = "${lookup(var.apim_products[count.index],"subscription_required","true")}"
  subscriptions_limit   = "${lookup(var.apim_products[count.index],"subscriptions_limit","100")}"
  approval_required     = "${lookup(var.apim_products[count.index],"approval_required","true")}"
  published             = "${lookup(var.apim_products[count.index],"published","true")}"
}

resource "azurerm_api_management_product_policy" "product_policies" {
  count               = "${length(var.apim_product_policies)}"
  product_id          = "${lookup(var.apim_product_policies[count.index],"id")}"
  api_management_name = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  xml_content = "${lookup(var.apim_product_policies[count.index],"xml_content")}"
}

resource "azurerm_api_management_api" "apis" {
  count               = "${length(var.apim_apis)}"
  name                = "${lookup(var.apim_apis[count.index],"name")}"
  api_management_name = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  display_name = "${lookup(var.apim_apis[count.index],"display_name","${lookup(var.apim_groups[count.index],"name")}")}"
  description  = "${lookup(var.apim_apis[count.index],"description","---")}"
  revision     = "${lookup(var.apim_apis[count.index],"revision","1")}"
  path         = "${lookup(var.apim_apis[count.index],"path","api/v1")}"
  protocols    = ["${lookup(var.apim_apis[count.index],"protocols","https")}"]

  # import {
  #   content_format = "swagger-link-json"
  #   content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  # }
}

resource "azurerm_api_management_product_api" "apim_product_api_bindings" {
  count      = "${length(var.apim_product_api_bindings)}"
  api_name   = "${lookup(var.apim_product_api_bindings[count.index],"api_name")}"
  product_id = "${azurerm_api_management_product.products.id}"

  product_id          = "${lookup(var.apim_product_api_bindings[count.index],"product_id")}"
  api_management_name = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_api_management_api_operation" "operation" {
  operation_id        = "createService"
  api_name            = "${azurerm_api_management_api.apis.name}"
  api_management_name = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  display_name        = "Delete User Operation"
  method              = "POST"
  url_template        = "/adm/services"
  description         = "This can only be done by the logged in user."

  response {
    status_code = 200
  }
}

## 27868
resource "azurerm_api_management_api_operation_policy" "example" {
  api_name            = "${azurerm_api_management_api_operation.example.api_name}"
  api_management_name = "${azurerm_api_management_api_operation.example.api_management_name}"
  resource_group_name = "${azurerm_api_management_api_operation.example.resource_group_name}"
  operation_id        = "${azurerm_api_management_api_operation.example.operation_id}"

  xml_content = <<XML
<policies>
  <inbound>
    <find-and-replace from="xyz" to="abc" />
  </inbound>
</policies>
XML
}

# "type": "Microsoft.ApiManagement/service/identityProviders
#            "properties": {
#                 "clientId": "0c927558-7d07-482a-8c72-509e163eeeff",
#                 "clientSecret": "4{+cpns2we31249L",
#                 "type": "aadB2C",
#                 "authority": "login.microsoftonline.com",
#                 "allowedTenants": [
#                     "agidweb.onmicrosoft.com"
#                 ],
#                 "signupPolicyName": "B2C_1_SignUpIn",
#                 "signinPolicyName": "B2C_1_SignUpIn",
#                 "passwordResetPolicyName": "B2C_1_PasswordReset"
#             }


#   "type": "Microsoft.ApiManagement/service/notifications",
#   AccountClosedPublisher
# "properties": {
#       "title": "Close account message",
#       "description": "The following email recipients and users will receive email notifications when developer closes his account",
#       "recipients": {
#           "emails": [],
#           "users": []
#       }
#   }


# "type": "Microsoft.ApiManagement/service/notifications/recipientEmails",
# "name": "[concat(parameters('service_agid_apim_prod_name'), '/BCC/danilo.spinelli@agid.gov.it'
#   "properties": {
#                 "email": "danilo.spinelli@agid.gov.it"
#             }
#  "type": "Microsoft.ApiManagement/service/notifications/recipientEmails",
# PurchasePublisherNotificationMessage/danilo.spinelli@agid.gov.it'
#       "properties": {
#                 "email": "danilo.spinelli@agid.gov.it"
#             }
#  "type": "Microsoft.ApiManagement/service/notifications/recipientEmails",
#  QuotaLimitApproachingPublisherNotificationMessage/danilo.spinelli@agid.gov.it')]",
#      "properties": {
#       "email": "danilo.spinelli@agid.gov.it"
#   }
#  "type": "Microsoft.ApiManagement/service/notifications/recipientEmails",
#  RequestPublisherNotificationMessage/danilo.spinelli@agid.gov.it')]",
#   "properties": {
#             "email": "danilo.spinelli@agid.gov.it"
#         }


# "type": "Microsoft.ApiManagement/service/apis/diagnostics",
# digital-citizenship-api/applicationinsights
#  "properties": {
#                 "alwaysLog": "allErrors",
#                 "enableHttpCorrelationHeaders": true,
#                 "loggerId": "[resourceId('Microsoft.ApiManagement/service/loggers', parameters('service_agid_apim_prod_name'), 'agid-appinsights-prod')]",
#                 "sampling": {
#                     "samplingType": "fixed",
#                     "percentage": 100
#                 },
#                 "frontend": {
#                     "request": {
#                         "headers": [],
#                         "body": {
#                             "bytes": 1024
#                         }
#                     },
#                     "response": {
#                         "headers": [],
#                         "body": {
#                             "bytes": 1024
#                         }
#                     }
#                 },
#                 "backend": {
#                     "request": {
#                         "headers": [],
#                         "body": {
#                             "bytes": 1024
#                         }
#                     },
#                     "response": {
#                         "headers": [],
#                         "body": {
#                             "bytes": 1024
#                         }
#                     }
#                 }
#             }


#      "type": "Microsoft.ApiManagement/service/loggers",
# agid-appinsights-prod'
# "properties": {
#                 "loggerType": "applicationInsights",
#                 "credentials": {
#                     "instrumentationKey": "{{Logger-Credentials-5b3b25a6a9ab400e1c32d363}}"
#                 },
#                 "isBuffered": true,
#                 "resourceId": "[parameters('components_agid_appinsights_prod_externalid')]"
#             }
# "type": "Microsoft.ApiManagement/service/loggers",
# azuremonitor
#         "properties": {
#             "loggerType": "azureMonitor",
#             "isBuffered": true,
#             "credentials": {}
#         }
# "type": "Microsoft.ApiManagement/service/apis/diagnostics/loggers",
#  "name": "[concat(parameters('service_agid_apim_prod_name'), '/digital-citizenship-api/applicationinsights/agid-appinsights-prod')]",
# "properties": {
#                 "loggerType": "applicationInsights",
#                 "credentials": {
#                     "instrumentationKey": "{{Logger-Credentials-5b3b25a6a9ab400e1c32d363}}"
#                 },
#                 "isBuffered": true,
#                 "resourceId": "[parameters('components_agid_appinsights_prod_externalid')]"
#             }

