locals {
  storage_account_name = "${replace("${lower(("${var.function_app_name}${var.environment}funcsta"))}", "/[^a-z0-9]/","")}"
  app_service_plan_name = "${var.function_app_name}-${var.env}-plan"
  function_app_name = "${var.function_app_name}-${var.env}-func"
}

resource "azurerm_storage_account" "funcsta" {
  name                      = "${local.storage_account_name}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  account_tier              = "Standard"
  account_replication_type  = "${var.account_replication_type}"
  enable_blob_encryption    = true
  enable_file_encryption    = true
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
}

resource "azurerm_function_app" "funcapp" {
  name                      = "${local.function_app_name}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  app_service_plan_id       = "${azurerm_app_service_plan.funcasp.id}"
  storage_connection_string = "${azurerm_storage_account.funcsta.primary_connection_string}"
  version                   = "${var.function_version}"
  app_settings {
    # "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.test.instrumentation_key}"
    "FUNCTIONS_EXTENSION_VERSION" = "~2"
    "FUNCTIONS_WORKER_RUNTIME" = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "8.11.1"
  }
}

# set up git deployment
provisioner "local-exec" {
  command = "${var.git_enabled ? join("", list("az functionapp deployment source config-local-git --ids ", azurerm_function_app.funcapp.id)) : "true"}"
}
