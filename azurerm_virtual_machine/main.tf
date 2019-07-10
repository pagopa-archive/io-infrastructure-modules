# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${var.resource_group_name}"
}

data "azurerm_resource_group" "rg_storage_account" {
  name = "${var.storage_account_resource_group_name}"
}

data "azurerm_resource_group" "rg_infra" {
  name = "${var.infra_resource_group_name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.azurerm_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "subnet" {
  name                 = "${local.azurerm_subnet_name}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_image" "custom_image" {
  name                = "${var.custom_image_name}"
  resource_group_name = "${data.azurerm_resource_group.rg_infra.name}"
}

data "azurerm_storage_account" "storage_account_vms_bd" {
  name                = "${local.azurerm_storage_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg_storage_account.name}"
}

data "azurerm_key_vault" "key_vault" {
  name                = "${var.azurerm_key_vault_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault_secret" "default_admin_password" {
  name         = "${var.azurerm_key_vault_secret_default_admin_password_name}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "${var.azurerm_key_vault_secret_ssh_public_key_name}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}

# New infrastructure

resource "azurerm_public_ip" "pip" {
  count               = "${var.public_ip}"
  name                = "${local.azurerm_public_ip_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "security_group" {
  name                = "${local.azurerm_network_security_group_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "security_rule" {
  count                       = "${length(var.azurerm_network_security_rules)}"
  name                        = "${lookup(var.azurerm_network_security_rules[count.index], "name")}"
  priority                    = "${count.index + 1000}"
  direction                   = "${lookup(var.azurerm_network_security_rules[count.index], "direction")}"
  access                      = "${lookup(var.azurerm_network_security_rules[count.index], "access")}"
  protocol                    = "${lookup(var.azurerm_network_security_rules[count.index], "protocol")}"
  source_port_range           = "${lookup(var.azurerm_network_security_rules[count.index], "source_port_range")}"
  destination_port_range      = "${lookup(var.azurerm_network_security_rules[count.index], "destination_port_range")}"
  source_address_prefix       = "${lookup(var.azurerm_network_security_rules[count.index], "source_address_prefix")}"
  destination_address_prefix  = "${lookup(var.azurerm_network_security_rules[count.index], "destination_address_prefix")}"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.security_group.name}"
}

resource "azurerm_network_interface" "nic" {
  name                      = "${local.azurerm_network_interface_name}"
  location                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name       = "${data.azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"
  internal_dns_name_label   = "${var.vm_name}"

  ip_configuration {
    name                          = "${local.azurerm_network_interface_ip_configuration_name}"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.azurerm_network_interface_ip_configuration_private_ip_address}"
    public_ip_address_id          = "${var.public_ip ? join("", azurerm_public_ip.pip.*.id) : ""}"
  }
}

### Virtual Machine

resource "azurerm_virtual_machine" "vm" {
  name                          = "${local.azurerm_virtual_machine_name}"
  location                      = "${data.azurerm_resource_group.rg.location}"
  resource_group_name           = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids         = ["${azurerm_network_interface.nic.id}"]
  vm_size                       = "${var.azurerm_virtual_machine_size}"
  delete_os_disk_on_termination = true

  storage_image_reference {
    id = "${data.azurerm_image.custom_image.id}"
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${data.azurerm_storage_account.storage_account_vms_bd.primary_blob_endpoint}"
  }

  storage_os_disk {
    name              = "${local.azurerm_virtual_machine_storage_os_disk_name}"
    create_option     = "FromImage"
    managed_disk_type = "${var.azurerm_virtual_machine_storage_os_disk_type}"
  }

  os_profile {
    computer_name  = "${local.azurerm_virtual_machine_os_profile_computer_name}"
    admin_username = "${var.default_admin_username}"
    admin_password = "${data.azurerm_key_vault_secret.default_admin_password.value}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.default_admin_username}/.ssh/authorized_keys"
      key_data = "${data.azurerm_key_vault_secret.ssh_public_key.value}"
    }
  }

  tags = {
    environment = "${var.environment}"
  }

  # Do not recreate the VM if the password is changed
  lifecycle {
    ignore_changes = ["os_profile.0.admin_password"]
  }
}
