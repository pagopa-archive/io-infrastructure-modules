# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

# New infrastructure

resource "azurerm_storage_account" "webblob" {
  name                     = "${local.azurerm_storage_account_name}"
  resource_group_name      = "${data.azurerm_resource_group.rg.name}"
  location                 = "${data.azurerm_resource_group.rg.location}"

  account_kind             = "StorageV2"

  account_tier             = "${var.azurerm_storage_account_account_tier}"
  account_replication_type = "${var.azurerm_storage_account_account_replication_type}"

  # azure client must be logged in before running this
  # install az extension add --name storage-preview
  # see https://github.com/terraform-providers/terraform-provider-azurerm/issues/1903

  provisioner "local-exec" {
    command = "az storage blob service-properties update --account-name ${azurerm_storage_account.webblob.name} --static-website --index-document index.html --404-document 404.html"
  }

  tags = {
    environment = "${var.environment}"
  }
}
