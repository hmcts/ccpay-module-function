
variable "location" {
  default     = "UK South"
  description = "The azure datacenter location where the resources should be created."
}

variable "env" {
  description = "The environment where the infrastructure is deployed."
}

variable "resource_group_name" {
  description = "The resource group where the resources should be created."
}

variable "function_app_name" {
  description = "The name for the function app. Without environment naming."
}

variable "function_version" {
  default     = "~1"
  description = "The runtime version the function app should have."
}

variable "account_replication_type" {
  default = "LRS"
  description = "The Storage Account replication type. See azurerm_storage_account module for posible values."
}

variable "plan_settings" {
  type        = "map"
  description = "Definition of the dedicated plan to use"

  default = {
    kind     = "windows" # Linux or Windows
    size     = "I1"
    capacity = 1
  }
}

variable "app_settings" {
  default     = {}
  type        = "map"
  description = "Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"

  default = {}
}

variable "plan_type" {
  description = "What kind of plan to use (dedicated or consumption)"
}


variable "storage_account_name" {
  description = "The name of the storage account for WebJobs, default = $function_app_name"
  default     = ""
}

variable "service_plan_name" {
  description = "The name of the App Service Plan, default = $function_app_name"
  default     = ""
}

variable "git_enabled" {
  description = "Set deployment mode to local git"
  default     = true
}

variable "site_config" {
  description = "A key-value pair for Site Config"
  type        = "list"

  default = [{
    always_on = true
  }]
}
