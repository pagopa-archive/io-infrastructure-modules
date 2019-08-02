output "azurerm_dns_zone_name" {
  description = "The DNS zone configured where records have been configured."
  value       = "${data.azurerm_dns_zone.dns_zone.name}"
}
