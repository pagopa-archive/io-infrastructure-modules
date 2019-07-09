resource "null_resource" "ssh_key_secret" {
  provisioner "local-exec" {
    command = <<EOF
      ansible-playbook azure_secret_ssh_key.yml --extra-vars "azure_secretsshkey_vault_name=${local.azurerm_key_vault_name} 
      azure_secretsshkey_key=${var.azurerm_key_vault_ssh_keys_private_secret_name} 
      azure_secretsshkey_key_pub=${var.azurerm_key_vault_ssh_keys_public_secret_name} 
      azure_secretsshkey_email=${var.azurerm_key_vault_ssh_keys_email}"
EOF

    working_dir = "ansible"
  }
}
