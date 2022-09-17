# Create an output for resource group id
output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

# create an output for the storage account name
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}