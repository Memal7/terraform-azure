# configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# create a resource group
resource "azurerm_resource_group" "test" {
  name     = "rg-terraform"
  location = "nordeurope"
}

# create a storage account
resource "azurerm_storage_account" "test" {
  name                     = "stgaccacctest001"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}