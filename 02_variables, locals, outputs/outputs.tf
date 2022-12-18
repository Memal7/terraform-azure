# create an output for resource group id
output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

# create an output for the storage account name
output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

# create an output for container registry name
output "acr_name" {
  value = azurerm_container_registry.acr.name
}