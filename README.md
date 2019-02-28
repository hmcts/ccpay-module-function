
## Create a Function App in Azure

This terraform module deploys a Function App on a given app service plan (shared) in Azure.

Creates following resources automatically
- Resource group
- Storage account
- Function app

### Usage

```hcl
module "function_app" {
  source = "git@github.com:hmcts/ccpay-module-function?ref=master"
  env = "${var.env}"
  location = "${var.location}"
  product = "${var.product}"
  account_replication_type = "LRS"
  app_service_plan_id = "${var.asp_resource_id}"
  common_tags = "${var.common_tags}"
  app_settings {
      "FUNCTIONS_WORKER_RUNTIME" = "node"
    }
}

```

### Inputs

##### location
The azure datacenter location where the resources should be created.

##### product
The name for the function app.

##### account_replication_type
The Storage Account replication type. See azurerm_storage_account module for possible values. Defaults to "LRS".

##### app_service_plan_id
The service plan id to use.

##### app_settings
Application settings to insert on creating the function app. 

##### environment
The environment where the infrastructure is deployed.

##### function_version
The runtime version the function app should have. Defaults to "~2"

### Outputs

##### storage_account_name
The name of the storage account created for the function app.

##### storage_account_connection_string
The primary connection string to the storage account created for the function app.

##### funcapp_id
The id of the created function app.

##### default_hostname
Unique hostname to reach the function app.
