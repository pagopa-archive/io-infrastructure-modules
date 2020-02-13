data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_dns_zone" "dns_zone" {
  name                = "${var.dns_zone_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_dns_cname_record" "cdn_cname_record" {
  name                = "${var.cname_record}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  ttl                 = "${var.dns_record_ttl}"
  record              = "${local.azurerm_cdn_endpoint_hostname}"
}

resource "null_resource" "cdn_custom_domain" {
  depends_on = [ "azurerm_dns_cname_record.cdn_cname_record" ]

  # needs az cli > 2.0.81
  # see https://github.com/Azure/azure-cli/issues/12152

  provisioner "local-exec" {
    command =<<EOT
      az cdn custom-domain create \
        --resource-group ${data.azurerm_resource_group.rg.name} \
        --endpoint-name ${local.azurerm_cdn_endpoint_name} \
        --profile-name ${local.azurerm_cdn_profile_name} \
        --name ${local.azurerm_cdn_custom_domain_name} \
        --hostname ${local.azurerm_cdn_custom_domain_host_name}

      az cdn custom-domain enable-https \
        --resource-group ${data.azurerm_resource_group.rg.name} \
        --endpoint-name ${local.azurerm_cdn_endpoint_name} \
        --profile-name ${local.azurerm_cdn_profile_name} \
        --name ${local.azurerm_cdn_custom_domain_name}
    EOT
  }
}
