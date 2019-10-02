# Existing infrastructure
data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

// IP module
module "gateway_ip" {
    # source = "git::git@github.com:teamdigitale/io-infrastructure-modules.git//azurerm_public_ip"
    source = "/Users/rchessa/Projects/TeamDigitale/io-infrastructure-modules/azurerm_public_ip/"
    
    # Public IP module variables
    azurerm_public_ip_name      = "ag-01"
    azurerm_resource_group_name = "${data.azurerm_resource_group.rg.name}"

    # Module Variables
    environment          = "${var.environment}"
    location             = "${var.location}"
    resource_name_prefix = "${var.resource_name_prefix}"
}


// Subnet modules
module "subnet_frontend" {
    # source = "git::git@github.com:teamdigitale/io-infrastructure-modules.git//azurerm_subnet"
    source = "/Users/rchessa/Projects/TeamDigitale/io-infrastructure-modules//azurerm_subnet/"
  
    # Azure subnet module variables
    vnet_name                        = "common"
    subnet_name                      = "ag-frontend"
    azurerm_subnet_address_prefix    = "172.16.55.0/24"
    add_security_group               = false
    azurerm_network_security_rules   = []
    set_subnet_delegation            = false

     # Module Variables
    environment          = "${var.environment}"
    location             = "${var.location}"
    resource_name_prefix = "${var.resource_name_prefix}"
}
resource "azurerm_application_gateway" "ag_as_waf" {
  name                = "${local.azurerm_resource_group_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  sku {
    name     = "${var.azurerm_application_gateway_sku_name}"
    tier     = "${var.azurerm_application_gateway_sku_tier}"
  }

  autoscale_configuration {
      min_capacity = "${var.azurerm_application_gateway_autoscaling_configuration_min_capacity}"
      max_capacity = "${var.azurerm_application_gateway_autoscaling_configuration_max_capacity}"
  }

  gateway_ip_configuration {
    name      = "${var.azurerm_application_gateway_gateway_ip_configuration_name}"
    subnet_id = "${module.subnet_frontend.azurerm_subnet_id}"
  }

  frontend_port {
    name = "${local.azurerm_application_gateway_frontend_port_name}"
    port = "${var.azurerm_application_gateway_frontend_port_port}"
  }

  frontend_ip_configuration {
    name                 = "${local.azurerm_application_gateway_frontend_ip_configuration_name}"
    public_ip_address_id = "${module.gateway_ip.azurerm_public_ip_id}"
  }

  backend_address_pool {
    name         = "${local.azurerm_application_gateway_backend_address_pool_name}"
    ip_addresses = ""
  }

  backend_http_settings {
    name                  = "${local.azurerm_application_gateway_backend_http_setting_name}"
    cookie_based_affinity = "Disabled"
    path                  = "/status-0123456789abcdef"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 180
  }

  http_listener {
    name                           = "${local.azurerm_application_gateway_http_listener_name}"
    frontend_ip_configuration_name = "${local.azurerm_application_gateway_frontend_ip_configuration_name}"
    frontend_port_name             = "${local.azurerm_application_gateway_frontend_port_name}"
    protocol                       = "Https"
  }

  request_routing_rule {
    name                       = "${local.azurerm_application_gateway_request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.azurerm_application_gateway_http_listener_name}"
    backend_address_pool_name  = "${local.azurerm_application_gateway_backend_address_pool_name}"
    backend_http_settings_name = "${local.azurerm_application_gateway_backend_http_setting_name}"
  }

  waf_configuration {
      enabled          = "${var.azurerm_application_gateway_waf_configuration_enabled}"
      firewall_mode    = "${var.azurerm_application_gateway_waf_configuration_firewall_mode}"
      rule_set_type    = "${var.azurerm_application_gateway_waf_configuration_rule_set_type}"
      rule_set_version = "${var.azurerm_application_gateway_waf_configuration_rule_set_version}"
  }
}
