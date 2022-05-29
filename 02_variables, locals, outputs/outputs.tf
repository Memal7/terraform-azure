output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

# creaze an output for the storage account name
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}