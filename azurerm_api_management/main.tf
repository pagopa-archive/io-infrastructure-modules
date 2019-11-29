# API management

# Create and configure the API management service

# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
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

data "azurerm_client_config" "current" {}

# New infrastructure

resource "azurerm_template_deployment" "apim" {
  # name is the deploymeny name on azure
  name                = "apim"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  template_body       = "${file("apim-create.json")}"
  parameters          = {
    "publisherEmail"          = "${var.publisher_email}"
    "publisherName"           = "${var.publisher_name}"
    "sku"                     = "${var.sku_name}"
    "proxyCustomHostname1"    = "${local.hostname_configurations_hostname}"
    "keyVaultIdToCertificate" = "${local.hostname_configurations_keyvault_id}"
    "keyVaultName"            = "${local.azurerm_key_vault_name}"
    "apiName"                 = "${local.azurerm_apim_name}"
    "location"                = "${data.azurerm_resource_group.rg.location}"
    "subnetRef"               = "${data.azurerm_subnet.apim_subnet.id}"
  }
  deployment_mode = "Incremental"
}
