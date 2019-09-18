# The module configure an web test from an url

# Existing infrastructure
data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure
resource "azurerm_application_insights_web_test" "web_test" {
  count = "${length(var.web_tests)}"

  name = "${lookup(var.web_tests[count.index], "name")}"

  resource_group_name     = "${local.azurerm_resource_group_name}"
  application_insights_id = "/subscriptions/ec285037-c673-4f58-b594-d7c480da4e8b/resourceGroups/io-dev-rg/providers/microsoft.insights/components/io-dev-ai-generic-web-tests"

  kind          = "ping"
  retry_enabled = true
  timeout       = 30

  location      = "westeurope"
  geo_locations = [
    "emea-nl-ams-azr",
    "us-va-ash-azr"
  ]

  configuration = <<XML
<WebTest Name="${lookup(var.web_tests[count.index], "name")}" Id="ABD48585-0831-40CB-9069-682EA6BB3583" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="a5f10126-e4cd-570d-961c-cea43999a200" Version="1.1" Url="${lookup(var.web_tests[count.index], "url")}" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML
}
