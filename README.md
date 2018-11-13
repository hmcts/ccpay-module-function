
## Create a Function App in Azure

This terraform module deploys a Function App on app service plan in Azure.

Creates following resources automatically
- Storage account
- App service plan
- Function app

### Usage

```hcl
module "function_app" {
  source = "git@github.com:hmcts/ccpay-module-function?ref=master"
  env = "${var.env}"
  location = "${var.location}"
  function_app_name = "payment-node"
  resource_group_name = "${var.resource_group_name}"
  account_replication_type = "LRS"
  plan_type = "dedicated"
  common_tags = "${var.common_tags}"
  app_settings {
      "FUNCTIONS_EXTENSION_VERSION" = "~2"
    }
}

```

### Inputs

##### resource_group_name
The resource group where the resources should be created.

##### location
The azure datacenter location where the resources should be created.

##### function_app_name
The name for the function app.

##### account_replication_type
The Storage Account replication type. See azurerm_storage_account module for posible values. Defaults to "LRS".

##### plan_type
The service plan to use (dedicated or consumption). Defaults to consumption. Can be customise dedicated plan using plan_settings variable.

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
