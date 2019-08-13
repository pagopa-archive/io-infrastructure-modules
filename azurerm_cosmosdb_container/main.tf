# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "${local.azurerm_cosmosdb_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# New infrastructure

# Create container
module "azurerm_cosmosdb_sql_container" {
  source                 = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version            = "2016-03-31"
  type                   = "Microsoft.DocumentDB/databaseAccounts/apis/databases/containers"
  enable_output          = false
  name                   = "${data.azurerm_cosmosdb_account.cosmosdb_account.name}/sql/${local.azurerm_cosmosdb_documentdb_name}/${var.container_name}"
  resource_group_name    = "${data.azurerm_resource_group.rg.name}"
  location               = "${var.location}"
  random_deployment_name = true

  tags = {
    environment = "${var.environment}"
  }

  properties {
    resource {
      id = "${var.container_name}"

      partitionKey = {
        paths = ["${var.partitionKey_paths}"]
        kind  = "Hash"
      }

      indexingPolicy = {
        indexingMode  = "${var.indexingMode}"
        includedPaths = "${var.includedPaths}"
        excludedPaths = []
      }
    }

    options = {}
  }
}

# module "azurerm_cosmosdb_sql_container_throughput" {
#   source                 = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
#   api_version            = "2016-03-31"
#   type                   = "Microsoft.DocumentDB/databaseAccounts/apis/databases/containers/settings"
#   enable_output          = false
#   name                   = "${data.azurerm_cosmosdb_account.cosmosdb_account.name}/sql/${local.azurerm_cosmosdb_documentdb_name}/${var.container_name}/throughput"
#   resource_group_name    = "${data.azurerm_resource_group.rg.name}"
#   location               = "${var.location}"
#   random_deployment_name = true

#   tags = {
#     environment = "${var.environment}"
#   }

#   properties {
#     resource {
#       throughput = "${var.container_throughput}"
#     }
#   }
# }
