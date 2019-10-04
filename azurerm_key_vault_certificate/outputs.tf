output "azurerm_key_vault_certificate_id" {
    description = "The Key Vault Certificate ID."
    value = "${azurerm_key_vault_certificate.certificate.id}"
}

output "azurerm_key_vault_certificate_secret_id" {
    description = "The ID of the associated Key Vault Secret."
    value = "${azurerm_key_vault_certificate.certificate.secret_id}"
}

output "azurerm_key_vault_certificate_certificate_data" {
    description = "The raw Key Vault Certificate."
    value = "${azurerm_key_vault_certificate.certificate.certificate_data}"
}
