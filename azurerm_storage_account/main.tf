# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_virtual_network" "vnets" {
  count               = "${length(var.allowed_subnets)}"
  name                = "${lookup(var.allowed_subnets[count.index], "vnet")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "subnets" {
  count                = "${length(var.allowed_subnets)}"
  name                 = "${lookup(var.allowed_subnets[count.index], "subnet")}"
  virtual_network_name = "${lookup(var.allowed_subnets[count.index], "vnet")}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

resource "azurerm_storage_account" "storage_account" {
  count                    = "${var.set_firewall}"
  name                     = "${local.azurerm_storage_account_name}"
  resource_group_name      = "${data.azurerm_resource_group.rg.name}"
  location                 = "${var.location}"
  account_tier             = "${var.azurerm_storage_account_account_tier}"
  account_replication_type = "${var.azurerm_storage_account_account_replication_type}"

  network_rules {
    ip_rules                   = ["${var.allowed_ips}"]
    virtual_network_subnet_ids = ["${data.azurerm_subnet.subnets.*.id}"]
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_account" "storage_account_no_firewall" {
  count                    = "${1 - var.set_firewall}"
  name                     = "${local.azurerm_storage_account_name}"
  resource_group_name      = "${data.azurerm_resource_group.rg.name}"
  location                 = "${var.location}"
  account_tier             = "${var.azurerm_storage_account_account_tier}"
  account_replication_type = "${var.azurerm_storage_account_account_replication_type}"

  tags = {
    environment = "${var.environment}"
  }
}
