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
  source              = "git@github.com:teamdigitale/terraform-azurerm-resource.git"
  api_version         = "2016-03-31"
  type                = "Microsoft.DocumentDB/databaseAccounts/apis/databases/containers"
  name                = "${data.azurerm_cosmosdb_account.cosmosdb_account.name}/sql/${local.azurerm_cosmosdb_documentdb_name}/testcontainer"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  # tags                = "${var.tags}"

properties {
    resource = <<EOF
    {
    	"id": "testcontainer",
			"partitionKey": {
						"paths": [
						"/MyPartitionKey1"
						],
						"kind": "Hash"
			},
    	"indexingPolicy": {
    		"indexingMode": "consistent",
    		"automatic": true,
    		"includedPaths": [{
    			"path": "/*",
    			"indexes": [{
    					"kind": "Range",
    					"dataType": "Number",
    					"precision": -1
    				},
    				{
    					"kind": "Range",
    					"dataType": "String",
    					"precision": -1
    				},
    				{
    					"kind": "Spatial",
    					"dataType": "Point"
    				}
    			]
    		}],
    		"excludedPaths": []
    	},
    	"partitionKey": {
    		"paths": [
    			"string"
    		],
    		"kind": "string"
    	},
    	"defaultTtl": "integer",
    	"uniqueKeyPolicy": {
    		"uniqueKeys": [{
    			"paths": [
    				"string"
    			]
    		}]
    	},
    	"conflictResolutionPolicy": {
    		"mode": "string",
    		"conflictResolutionPath": "string",
    		"conflictResolutionProcedure": "string"
    	}
    }
    EOF
    options = {}
  }

  # sku {
  #   name     = "${var.sku_name}"
  #   capacity = "${var.sku_capacity}"
  # }
}