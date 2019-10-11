# Existing infrastructure
data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${local.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}
data "azurerm_key_vault_secret" "certificate" {
  name         = "apidevioitaliait"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

# IP module
module "gateway_ip" {
    source = "git::git@github.com:teamdigitale/io-infrastructure-modules.git//azurerm_public_ip"
    
    # Public IP module variables
    azurerm_public_ip_name      = "ag-01"
    azurerm_resource_group_name = "${data.azurerm_resource_group.rg.name}"
    azurerm_public_ip_sku       = "Standard"

    # Module Variables
    environment                 = "${var.environment}"
    location                    = "${var.location}"
    resource_name_prefix        = "${var.resource_name_prefix}"
}

# Subnet modules
module "subnet_frontend" {
    source = "git::git@github.com:teamdigitale/io-infrastructure-modules.git//azurerm_subnet"
  
    # Azure subnet module variables
    vnet_name                      = "common"
    subnet_name                    = "ag-frontend"
    azurerm_subnet_address_prefix  = "172.16.55.0/24"
    add_security_group             = false
    azurerm_network_security_rules = []
    set_subnet_delegation          = false

    # Module Variables
    environment                    = "${var.environment}"
    location                       = "${var.location}"
    resource_name_prefix           = "${var.resource_name_prefix}"
}

# Application Gateway resource
resource "azurerm_application_gateway" "ag_as_waf" {
  name                = "${local.azurerm_application_gateway_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  sku {
    name = "${var.azurerm_application_gateway_sku_name}"
    tier = "${var.azurerm_application_gateway_sku_tier}"
  }

  autoscale_configuration {
      min_capacity = "${var.azurerm_application_gateway_autoscaling_configuration_min_capacity}"
      max_capacity = "${var.azurerm_application_gateway_autoscaling_configuration_max_capacity}"
  }

  gateway_ip_configuration {
    name      = "${local.azurerm_application_gateway_gateway_ip_configuration_name}"
    subnet_id = "${element(module.subnet_frontend.azurerm_subnet_id,0)}"
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
    ip_addresses = ["${var.azurerm_application_gateway_backend_address_pool_ip_addresses}"]
  }

  probe {
    host                = "api.dev.io.italia.it"
    name                = "${local.azurerm_application_gateway_probe_name}"
    interval            = "${var.azurerm_application_gateway_probe_interval}"
    protocol            = "${var.azurerm_application_gateway_probe_protocol}"
    path                = "/status-0123456789abcdef"
    timeout             = "${var.azurerm_application_gateway_probe_timeout}"
    unhealthy_threshold = "${var.azurerm_application_gateway_probe_unhealthy_threshold}"
  }

  backend_http_settings {
    name                  = "${local.azurerm_application_gateway_backend_http_setting_name}"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 180
    probe_name            = "${local.azurerm_application_gateway_probe_name}"
  }

  http_listener {
    name                           = "${local.azurerm_application_gateway_https_listener_name}"
    frontend_ip_configuration_name = "${local.azurerm_application_gateway_frontend_ip_configuration_name}"
    frontend_port_name             = "${local.azurerm_application_gateway_frontend_port_name}"
    protocol                       = "Https"
    ssl_certificate_name           = "${local.azurerm_application_gateway_ssl_certificate_name}"
    require_sni                    = true
    host_name                      = "api.dev.io.italia.it"
  }

  request_routing_rule {
    name                       = "${local.azurerm_application_gateway_request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.azurerm_application_gateway_https_listener_name}"
    backend_address_pool_name  = "${local.azurerm_application_gateway_backend_address_pool_name}"
    backend_http_settings_name = "${local.azurerm_application_gateway_backend_http_setting_name}"
  }

  waf_configuration {
      enabled          = "${var.azurerm_application_gateway_waf_configuration_enabled}"
      firewall_mode    = "${var.azurerm_application_gateway_waf_configuration_firewall_mode}"
      rule_set_type    = "${var.azurerm_application_gateway_waf_configuration_rule_set_type}"
      rule_set_version = "${var.azurerm_application_gateway_waf_configuration_rule_set_version}"
  }

  ssl_certificate {
    name     = "${local.azurerm_application_gateway_ssl_certificate_name}"
    data     = "${data.azurerm_key_vault_secret.certificate.value}"
    password = ""
  }
}

// Get log_analytics_workspace_id
data "azurerm_log_analytics_workspace" "workspace" {
  name                = "${local.azurerm_log_analytics_workspace_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

// Get Diagnostic settings for AG
data "azurerm_monitor_diagnostic_categories" "ag" {
  resource_id = "${azurerm_application_gateway.ag_as_waf.id}"
}

// Add diagnostic to AG
resource "azurerm_monitor_diagnostic_setting" "ag" {
  name               = "${local.azurerm_application_gateway_diagnostic_name}"
  target_resource_id = "${azurerm_application_gateway.ag_as_waf.id}"

  log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.workspace.id}"

  log {
    category = "${data.azurerm_monitor_diagnostic_categories.ag.logs[0]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.azurerm_application_gateway_diagnostic_logs_retention}"
    }
  }

  log {
    category = "${data.azurerm_monitor_diagnostic_categories.ag.logs[1]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.azurerm_application_gateway_diagnostic_logs_retention}"
    }
  }

  log {
    category = "${data.azurerm_monitor_diagnostic_categories.ag.logs[2]}"
    enabled  = true

    retention_policy {
      enabled = true
      days    = "${var.azurerm_application_gateway_diagnostic_logs_retention}"
    }
  }

  metric {
    category = "${data.azurerm_monitor_diagnostic_categories.ag.metrics[0]}"

    retention_policy {
      enabled = true
      days    = "${var.azurerm_application_gateway_diagnostic_metrics_retention}"
    }
  }
}
