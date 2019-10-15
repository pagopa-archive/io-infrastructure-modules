# The module configure a web test from an url

# Existing infrastructure
data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_application_insights" "generic_web_tests" {
  name                = "${local.azurerm_application_insight_name}"
  resource_group_name = "${local.azurerm_resource_group_name}"
}

# New infrastructure
resource "azurerm_application_insights_web_test" "web_test" {
  count = "${length(var.web_tests)}"

  name = "${lookup(var.web_tests[count.index], "name")}"

  resource_group_name     = "${local.azurerm_resource_group_name}"
  application_insights_id = "${data.azurerm_application_insights.generic_web_tests.id}"

  kind          = "ping"
  retry_enabled = true
  timeout       = 30
  enabled       = true

  location      = "${data.azurerm_resource_group.rg.location}"
  geo_locations = [
    "emea-nl-ams-azr",
    "us-va-ash-azr"
  ]

  configuration = <<XML
${lookup(var.web_tests[count.index], "xml")}"
XML
}
