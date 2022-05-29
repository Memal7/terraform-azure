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
  name     = var.resource_group
  location = var.location
}

# create a storage account
resource "azurerm_storage_account" "storage" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication_type

  tags = local.tags
}

# create a storage container
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# create sas state for storage account
data "azurerm_storage_account_sas" "state" {
  connection_string = azurerm_storage_account.storage.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

# expiry_time for sas token
  start  = timestamp()
  expiry = timeadd(timestamp(), "17520h")

# permissions for sas token
  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
  }
}