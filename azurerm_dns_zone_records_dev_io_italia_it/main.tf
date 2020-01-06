# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_dns_zone" "dns_zone" {
  name                = "${local.azurerm_dns_zone_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_public_ip" "kubernetes_public_ip" {
  name                = "${local.kubernetes_public_ip_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

# The module dynamically creates only A and CNAME records, as other record
# type still don't support dynamical record value definition (which will
# be instead supported from Terraform 0.12 with loops)

# Kubernetes start

resource "azurerm_dns_a_record" "kubernetes_a_record" {
  name                = "*.${var.aks_cluster_name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  ttl                 = "${var.dns_record_ttl}"
  records             = ["${data.azurerm_public_ip.kubernetes_public_ip.ip_address}"]
}

resource "azurerm_dns_cname_record" "kubernetes_cname_records" {
  count               = "${length(var.kubernetes_cname_records)}"
  name                = "${var.kubernetes_cname_records[count.index]}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  ttl                 = "${var.dns_record_ttl}"
  record              = "${var.kubernetes_cname_records[count.index]}.${var.aks_cluster_name}.${local.azurerm_dns_zone_name}"
}

# Kubernetes end

# Application Gateway start

resource "azurerm_dns_a_record" "application_gateway_a_record" {
  name                = "api"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  ttl                 = "${var.dns_record_ttl}"
  records             = ["51.105.102.218"]
}

# Application Gateway end

# Onboarding

resource "azurerm_dns_cname_record" "onboarding_cname_records" {
  count               = "${length(var.onboarding_cname_records)}"
  name                = "${var.onboarding_cname_records[count.index]}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  ttl                 = "${var.dns_record_ttl}"
  record              = "${var.onboarding_cname_records_targets[count.index]}"
}


