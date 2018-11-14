locals {
  storage_account_name = "${replace("${lower(("${var.resource_group_name}funcsta"))}", "/[^a-z0-9]/","")}"
}

resource "azurerm_storage_account" "funcsta" {
  name                      = "${local.storage_account_name}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  account_replication_type  = "${var.account_replication_type}"
  account_tier              = "Standard"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  tags                      ="${var.common_tags}"
}

resource "azurerm_function_app" "funcapp" {
  name                      = "${var.function_app_name}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  app_service_plan_id       = "${var.asp_resource_id}"
  storage_connection_string = "${azurerm_storage_account.funcsta.primary_connection_string}"
  version                   = "${var.function_version}"
  tags                      = "${var.common_tags}"
  app_settings              = "${merge(var.app_settings_defaults, var.app_settings)}"
  site_config               = "${var.site_config}"
}
