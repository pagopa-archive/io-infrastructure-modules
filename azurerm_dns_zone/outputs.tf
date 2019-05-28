output "azurerm_dns_zone_name" {
  description = "The full DNS name of the new zone."
  value       = "${azurerm_dns_zone.dns_zone.name}"
}

output "azurerm_dns_zone_zone_type" {
  description = "If the DNS zone is public or private."
  value       = "${azurerm_dns_zone.dns_zone.zone_type}"
}

output "azurerm_dns_zone_nameservers" {
  description = "The list of name servers used for the zone."
  value       = "${azurerm_dns_zone.dns_zone.name_servers}"
}
