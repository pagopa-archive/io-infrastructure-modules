data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

resource "null_resource" "cdn_custom_domain" {
  provisioner "local-exec" {
    command =<<EOT
      az cdn custom-domain create \
        --resource-group ${data.azurerm_resource_group.rg.name} \
        --endpoint-name ${local.azurerm_cdn_endpoint_name} \
        --profile-name ${local.azurerm_cdn_profile_name} \
        --name ${local.azurerm_cdn_custom_domain_name} \
        --hostname ${var.azurerm_cdn_custom_domain_host_name}

      az cdn custom-domain enable-https \
        --resource-group ${data.azurerm_resource_group.rg.name} \
        --endpoint-name ${local.azurerm_cdn_endpoint_name} \
        --profile-name ${local.azurerm_cdn_profile_name} \
        --name ${local.azurerm_cdn_custom_domain_name} \
    EOT
  }
}
