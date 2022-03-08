output "storage_account_name" {
  value       = azurerm_storage_account.mongodb_storage_account.name
  description = "Mongodb storage account"
}

output "access_key" {
  value       = azurerm_storage_account.mongodb_storage_account.primary_access_key
  description = "Mongodb storage account access key"
  sensitive   = true
}

output "container_name" {
  value       = azurerm_storage_container.mongodb_container.*.name
  description = "Mongodb storage container name"
}
