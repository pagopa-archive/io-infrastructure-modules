# New infrastructure resources

resource "azurerm_resource_group" "rg" {
  name     = "${local.azurerm_resource_group_name}"
  location = "${var.location}"
}
