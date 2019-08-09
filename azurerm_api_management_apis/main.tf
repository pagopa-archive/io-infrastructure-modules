# API management

# Create and configure the API management service

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_api_management" "api_management" {
  name                = "${local.azurerm_apim_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_api_management_api" "apim_apis" {
  count               = "${length(var.apim_apis)}"
  name                = "${lookup(var.apim_apis[count.index],"name")}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  display_name = "${lookup(var.apim_apis[count.index],"display_name","${lookup(var.apim_apis[count.index],"name")}")}"
  description  = "${lookup(var.apim_apis[count.index],"description","---")}"
  revision     = "${lookup(var.apim_apis[count.index],"revision","1")}"
  path         = "${lookup(var.apim_apis[count.index],"path","api/v1")}"
  protocols    = ["${split(",",lookup(var.apim_apis[count.index],"protocols","https"))}"]

  import {
    content_format = "swagger-json"
    content_value  = "${element(data.template_file.api_defs.*.rendered,count.index)}"
  }
}

data "template_file" "api_defs" {
  count    = "${length(var.apim_apis)}"
  template = "${file("${lookup(var.apim_apis[count.index],"name")}.json")}"

  vars = {
    display_name = "${lookup(var.apim_apis[count.index],"display_name","${lookup(var.apim_apis[count.index],"name")}")}"
    description  = "${lookup(var.apim_apis[count.index],"description","---")}"
    host         = "${lookup(var.apim_apis[count.index],"host","api.example.com")}"
    path         = "${lookup(var.apim_apis[count.index],"path","")}"
  }
}

resource "azurerm_api_management_api_operation" "apim_api_operations" {
  count               = "${length(var.apim_api_operations)}"
  operation_id        = "${lookup(var.apim_api_operations[count.index],"operation_id")}"
  api_name            = "${element(azurerm_api_management_api.apim_apis.*.name , index(azurerm_api_management_api.apim_apis.*.name, lookup(var.apim_api_operations[count.index],"api_name")))}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  display_name        = "${lookup(var.apim_api_operations[count.index],"display_name","${lookup(var.apim_api_operations[count.index],"api_name")}")}"
  method              = "${lookup(var.apim_api_operations[count.index],"method","GET")}"
  url_template        = "${lookup(var.apim_api_operations[count.index],"url_template")}"
  description         = "${lookup(var.apim_api_operations[count.index],"description","---")}"

  # template_parameter = ["${element(data.external.apim_api_operations_template_parameter.*.result,count.index)}"]
  # template_parameter = ["${lookup(element(data.external.apim_api_operations_template_parameter.*.result,count.index),"name","") != ""? list(element(data.external.apim_api_operations_template_parameter.*.result,count.index)) : "" }"]
  ## template_parameter = ["${element(data.external.apim_api_operations_template_parameter.*.result,count.index)}"]

  # "templateParameters": [
  #                   {
  #                       "name": "serviceId",
  #                       "required": true,
  #                       "values": [],
  #                       "type": "[parameters('operations_5a05960ad812e699f31de771_type')]"
  #                   }
  #               ]
}

# output "test" {
#   value = "${data.null_data_source.apim_api_operations_template_parameter.*.outputs["template_parameter"]}"
# }

# data "null_data_source" "apim_api_operations_template_parameter" {
#   count = "${length(var.apim_api_operations)}"

#   inputs = {
#     template_parameter = "${lookup(var.apim_api_operations[count.index],"template_parameter","[]")}"
#   }
# }
# data "external" "apim_api_operations_template_parameter" {
#   count   = "${length(var.apim_api_operations)}"
#   program = ["echo", "${lookup(var.apim_api_operations[count.index],"template_parameter","{}")}"]
# }

# output "value1" {
#   value = "${data.external.apim_api_operations_template_parameter.*.result}"
# }

resource "azurerm_api_management_api_operation_policy" "apim_api_operation_policies" {
  count               = "${length(var.apim_api_operation_policies)}"
  api_name            = "${element(azurerm_api_management_api.apim_apis.*.name , index(azurerm_api_management_api.apim_apis.*.name, lookup(var.apim_api_operation_policies[count.index],"api_name")))}"
  api_management_name = "${basename(data.azurerm_api_management.api_management.id)}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  operation_id        = "${lookup(var.apim_api_operation_policies[count.index],"operation_id")}"

  # xml_content         = "${lookup(var.apim_api_operation_policies[count.index],"xml_filename","${local.api_management_default_api_operation_policy}")}"
  xml_content = "${file("${lookup(var.apim_api_operation_policies[count.index],"xml_filename")}")}"
}
