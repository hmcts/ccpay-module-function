variable "product" {
  type = "string"
}

variable "subscription" {
  type = "string"
}

variable "location" {
  default     = "UK South"
  description = "The azure datacenter location where the resources should be created."
}

variable "env" {
  description = "The environment where the infrastructure is deployed."
}

variable "ilbIp" {
  default = "0.0.0.0"
}

variable "infra_location" {
  type    = "string"
  default = "core-infra"
}

variable "resource_group_name" {
  description = "The resource group where the resources should be created."
}

variable "asp_resource_id" {
  description = "The resource id of the app service plan to use."
}

variable "function_version" {
  default     = "~2"
  description = "The runtime version the function app should have."
}

variable "account_replication_type" {
  default = "LRS"
  description = "The Storage Account replication type. See azurerm_storage_account module for posible values."
}

variable "app_settings" {
  default     = {}
  type        = "map"
  description = "Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
}

variable "app_settings_defaults" {
  type = "map"

  default = {
    FUNCTIONS_WORKER_RUNTIME = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "8.11.1"
  }
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  type        = "map"
}

variable "storage_account_name" {
  description = "The name of the storage account for WebJobs"
  default     = ""
}

variable "service_plan_name" {
  description = "The name of the App Service Plan"
  default     = ""
}

variable "site_config" {
  description = "A key-value pair for Site Config"
  type        = "list"
  default = [{
    always_on = true
  }]
}
