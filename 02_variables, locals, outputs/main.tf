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
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication_type
}

# create a virtual network
resource "azurerm_virtual_network" "vnet" {
  depends_on = [azurerm_resource_group.rg]
  name                = var.vnet_name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = var.vnet_space
}

# create a subnet
resource "azurerm_subnet" "subnet" {
  depends_on = [azurerm_virtual_network.vnet]
  name                 = var.subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefix
}

# create a network security group
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

# create a network security group association
resource "azurerm_subnet_network_security_group_association" "snet01" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}