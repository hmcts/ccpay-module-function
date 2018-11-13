locals {
  storage_account_name = "${replace("${lower(("${var.resource_group_name}funcsta"))}", "/[^a-z0-9]/","")}"
  app_service_plan_name = "${var.function_app_name}-asp"
  // turn always on off in case of consumption plan while preserving custom site_config parameters
  site_config = ["${merge(
    var.site_config[0],
    map("always_on", lower(var.plan_type) == "consumption" ? false : lookup(var.site_config[0], "always_on"))
    )}"]
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

resource "azurerm_app_service_plan" "funcasp" {
  name                = "${local.app_service_plan_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  kind                = "${lower(var.plan_type) == "consumption" ? "FunctionApp" : var.plan_settings["kind"]}"
  sku {
    tier     = "${lower(var.plan_type) == "consumption" ? "Dynamic" : "Standard"}"
    size     = "${lower(var.plan_type) == "consumption" ? "Y1" : var.plan_settings["size"]}"
    capacity = "${lower(var.plan_type) == "consumption" ? 0 : var.plan_settings["capacity"]}"
  }
  tags                      ="${var.common_tags}"
}

resource "azurerm_function_app" "funcapp" {
  name                      = "${var.function_app_name}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  app_service_plan_id       = "${azurerm_app_service_plan.funcasp.id}"
  storage_connection_string = "${azurerm_storage_account.funcsta.primary_connection_string}"
  version                   = "${var.function_version}"
  tags                      = "${var.common_tags}"
  app_settings              = "${merge(var.app_settings_defaults, var.app_settings)}"
  site_config               = "${local.site_config}"
}
