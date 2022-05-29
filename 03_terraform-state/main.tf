# configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
}

provider "azurerm" {
  features {}
}

# create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-test-import"
  location = "westeurope"
}

# create a storage account
resource "azurerm_storage_account" "storage" {
  name                     = "stgacctestimport456"
  resource_group_name      = azurerm_resource_group.rg
  location                 = azurerm_resource_group.rg
  account_tier             = "Standard"
  account_replication_type = "LRS"
}