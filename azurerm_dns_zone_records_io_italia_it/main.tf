# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_resource_group" "aks_rg" {
  name = "${var.kubernetes_resource_group_name}"
}

data "azurerm_dns_zone" "dns_zone" {
  name                = "${local.azurerm_dns_zone_name}"
  resource_group_name = "agid-rg-prod"
  # resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_public_ip" "kubernetes_public_ip" {
  name                = "${local.kubernetes_public_ip_name}"
  resource_group_name = "${data.azurerm_resource_group.aks_rg.name}"
}

data "azurerm_public_ip" "vpn_dev_public_ip" {
  name                = "${local.vpn_dev_public_ip_name}"
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
  name                = "${lookup(var.kubernetes_cname_records[count.index], "name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  ttl                 = "${var.dns_record_ttl}"
  record              = "${lookup(var.kubernetes_cname_records[count.index], "name")}.${var.aks_cluster_name}.${local.azurerm_dns_zone_name}"
}

# Kubernetes end

# Mgmt start

# dev VPN
resource "azurerm_dns_a_record" "vpn_dev_a_record" {
  name                = "${var.vpn_dev_host_name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  ttl                 = "${var.dns_record_ttl}"
  records             = ["${data.azurerm_public_ip.vpn_dev_public_ip.ip_address}"]
}

# Mgmt end

# Developers portal start

# New dev portal
resource "azurerm_dns_cname_record" "developers_cname_records" {
  count               = "${length(var.developers_cname_records)}"
  name                = "${lookup(var.developers_cname_records[count.index], "name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  ttl                 = "${var.dns_record_ttl}"
  record              = "${lookup(var.developers_cname_records[count.index], "value")}"
}

# Developers portal end

# Mailgun start

# MX record
resource "azurerm_dns_mx_record" "mailgun_mx_record" {
  name                = "${lookup(var.mailgun_mx_record, "name")}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  ttl                 = "${var.dns_record_ttl}"

  record {
    preference = 10
    exchange   = "${lookup(var.mailgun_mx_record, "value_a")}"
  }

  record {
    preference = 10
    exchange   = "${lookup(var.mailgun_mx_record, "value_b")}"
  }
}

# cname for Mailgun API
resource "azurerm_dns_cname_record" "mailgun_cname_record" {
  name                = "${lookup(var.mailgun_cname_record, "name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  record              = "${lookup(var.mailgun_cname_record, "value")}"
  ttl                 = "${var.dns_record_ttl}"
}

# Mailgun end

# Mailup configuration start

# Mailup dkim and SPF txt records
resource "azurerm_dns_txt_record" "mailup_txt_records" {
  count               = "${length(var.mailup_txt_records)}"
  name                = "${lookup(var.mailup_txt_records[count.index], "name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  ttl                 = "${var.dns_record_ttl}"

  record {
    value = "${lookup(var.mailup_txt_records[count.index], "value")}"
  }
}

# Mailup cname records
resource "azurerm_dns_cname_record" "mailup_cname_records" {
  count               = "${length(var.mailup_cname_records)}"
  name                = "${lookup(var.mailup_cname_records[count.index], "name")}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  ttl                 = "${var.dns_record_ttl}"
  record              = "${lookup(var.mailup_cname_records[count.index], "value")}"
}

# Mailup configuration end
