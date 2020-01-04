data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_postgresql_server" "postgresql_server" {
  name                  = "${local.azurerm_postgresql_server_name}"
  location              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_postgresql_database" "postgresql_database" {
  name                  = "${var.azurerm_postgresql_db_name}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  server_name           = "${data.azurerm_postgresql_server.postgresql_server.name}"

  charset               = "UTF8"

  # English_United States.1252
  collation             = "${var.azurerm_postgresql_db_collation}"
}
