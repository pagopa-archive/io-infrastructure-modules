data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_storage_account" "sa" {
  name                = "${local.azurerm_storage_account_name}"
  resource_group_name = "${local.azurerm_resource_group_name}"
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                          = "${local.azurerm_cdn_endpoint_name}"
  resource_group_name           = "${data.azurerm_resource_group.rg.name}"
  location                      = "${data.azurerm_resource_group.rg.location}"

  profile_name                  = "${local.azurerm_cdn_endpoint_profile_name}"
  
  is_http_allowed               = "${var.azurerm_cdn_endpoint_is_http_allowed}"
  is_https_allowed              = "${var.azurerm_cdn_endpoint_is_https_allowed}"

  querystring_caching_behaviour = "${var.azurerm_cdn_endpoint_querystring_caching_behaviour}"

  origin_host_header            = "${data.azurerm_storage_account.sa.primary_web_host != "" ? 
                                     data.azurerm_storage_account.sa.primary_web_host : 
                                     data.azurerm_storage_account.sa.primary_blob_host}"

  origin {
    name      = "${local.azurerm_storage_account_name}"
    host_name = "${data.azurerm_storage_account.sa.primary_web_host != "" ? 
                   data.azurerm_storage_account.sa.primary_web_host : 
                   data.azurerm_storage_account.sa.primary_blob_host}"
  }

  tags = {
    environment = "${var.environment}"
  }
}
