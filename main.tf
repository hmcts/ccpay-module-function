locals {
  storage_account_name = "${replace("${lower(("${var.product}${var.env}sta"))}", "-", "")}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = "${var.location}"
  tags = "${var.common_tags}"
}

resource "azurerm_storage_account" "funcsta" {
  name                      = "${local.storage_account_name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_replication_type  = "${var.account_replication_type}"
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
  tags                      = "${var.common_tags}"
}

resource "azurerm_function_app" "funcapp" {
  name                      = "${var.product}-${var.env}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  app_service_plan_id       = "${var.asp_resource_id}"
  storage_connection_string = "${azurerm_storage_account.funcsta.primary_connection_string}"
  version                   = "${var.function_version}"
  tags                      = "${var.common_tags}"
  app_settings              = "${merge(var.app_settings_defaults, var.app_settings)}"
  site_config               = "${var.site_config}"
}

resource "random_integer" "makeDNSupdateRunEachTime" {
  min     = 1
  max     = 99999
}

resource "null_resource" "consul" {
  triggers {
    trigger = "${azurerm_function_app.funcapp.name}",
    forceRun = "${random_integer.makeDNSupdateRunEachTime.result}"
  }

  # register dns
  provisioner "local-exec" {
    command = "bash -e ${path.module}/createDns.sh '${var.product}-${var.env}' 'core-infra-${var.env}' '${path.module}' '${var.ilbIp}' '${var.subscription}'"
  }
}