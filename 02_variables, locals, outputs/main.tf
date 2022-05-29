# Configure the Azure provider
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

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

# Create a storage account
resource "azurerm_storage_account" "storage" {
  name                     = local.storage_name
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication_type
}

resource "azurerm_virtual_network" "vnet" {
  depends_on = [azurerm_resource_group.rg]
  name                = var.vnet_name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = var.vnet_space
}

resource "azurerm_subnet" "subnet" {
  depends_on = [azurerm_virtual_network.vnet]
  name                 = var.subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefix
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "Open"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "snet01" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}