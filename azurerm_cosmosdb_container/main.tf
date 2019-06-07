# Existing infrastructure

data "azurerm_resource_group" "rg" {
  name = "${local.azurerm_resource_group_name}"
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "${local.azurerm_cosmosdb_account_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql_database" {
  name                = "${local.azurerm_cosmosdb_documentdb_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  account_name        = "${data.azurerm_cosmosdb_account.cosmosdb_account.name}"
}

module "azurerm_cosmosdb_sql_container" {
  #   source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
#   deployment_mode        = "Complete"
  source                 = "./terraform-azurerm-resource"
  api_version            = "2016-03-31"
  type                   = "Microsoft.DocumentDB/databaseAccounts/apis/databases/containers"
  name                   = "${data.azurerm_cosmosdb_account.cosmosdb_account.name}/sql/${local.azurerm_cosmosdb_documentdb_name}/messages"
  resource_group_name    = "${data.azurerm_resource_group.rg.name}"
  location               = "${var.location}"
  random_deployment_name = true

  # tags                = "${var.tags}"

  properties {
    resource {
      id = "messages"

      partitionKey = {
        paths = ["/fiscalCode"]
        kind  = "Hash"
      }

      indexingPolicy = {
        indexingMode = "lazy"
automatic = true
        includedPaths = [
          {
            path = "/*"

            indexes = [
              {
                kind      = "Range"
                dataType  = "number"
                precision = -1
              },
                            {
                kind      = "Hash"
                dataType  = "String"
                precision = 3
              }
            ]
          }
        ]
        excludedPaths = []
      }
    }
    # options = {}
  }

  # sku {
  #   name     = "${var.sku_name}"
  #   capacity = "${var.sku_capacity}"
  # }
}

# data "template_file" "init" {
# #   vars = {
# #     consul_address = "${aws_instance.consul.private_ip}"
# #   }
#   template = <<EOF
# {
#                     "id": "testcontainer",
#                     "partitionKey": {
#                         "paths": [
#                             "/MyPartitionKey1"
#                         ],
#                         "kind": "Hash"
#                     },
#                     "indexingPolicy": {
#                         "indexingMode": "consistent",
#                         "includedPaths": [
#                             {
#                                 "path": "/*",
#                                 "indexes": [
#                                     {
#                                         "kind": "Range",
#                                         "dataType": "number",
#                                         "precision": -1
#                                     },
#                                     {
#                                         "kind": "Range",
#                                         "dataType": "string",
#                                         "precision": -1
#                                     }
#                                 ]
#                             }
#                         ],
#                         "excludedPaths": [
#                             {
#                                 "path": "/MyPathToNotIndex/*"
#                             }
#                         ]
#                     }
#                 }
# EOF


# }

