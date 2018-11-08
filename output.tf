output "storage_account_name" {
  description = "The name of the storage account created for the function app"
  value = "${azurerm_storage_account.funcsta.name}"
}

output "storage_account_connection_string" {
  description = "Connection string to the storage account created for the function app"
  value = "${azurerm_storage_account.funcsta.primary_connection_string}"
  sensitive = true
}

output "funcapp_name" {
  description = "Function App name (identical with input parameter..for now)"
  value       = "${local.function_app_name}"
}

output "funcapp_id" {
  description = "Function App unique ID"
  value       = "${azurerm_function_app.funcapp.id}"
}

output "default_hostname" {
  description = "Unique hostname to reach the Function App"
  value       = "${azurerm_function_app.funcapp.default_hostname}"
}