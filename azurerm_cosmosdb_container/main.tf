# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "${local.azurerm_cosmosdb_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

module "azurerm_cosmosdb_sql_container" {
  source                 = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version            = "2016-03-31"
  type                   = "Microsoft.DocumentDB/databaseAccounts/apis/databases/containers"
  enable_output          = false
  name                   = "${data.azurerm_cosmosdb_account.cosmosdb_account.name}/sql/${length(var.documentdb_name) >0 ? var.documentdb_name : local.azurerm_cosmosdb_documentdb_name}/${var.container_name}"
  resource_group_name    = "${data.azurerm_resource_group.rg.name}"
  location               = "${var.location}"
  random_deployment_name = true
  tags                   = "${var.tags}"

  properties {
    resource {
      id = "${var.container_name}"

      partitionKey = {
        paths = ["${var.partitionKey_paths}"]
        kind  = "Hash"
      }
    }

    options = {}
  }
}
