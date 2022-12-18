# specify provider, provider source and version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
# configure the specified provider
provider "azurerm" {
  features {}
}

# create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location

  tags = local.tags
}

# create a storage account module
module "storage" {
  source = "./Modules/Storage_Account"

  storage_name   = local.storage_name
  resource_group = azurerm_resource_group.rg.name
  location       = var.location
  https_only     = true
}

# create a virtual network
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.rg]
  name                = var.vnet_name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = var.vnet_space

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = ["10.0.0.0/24"]
  }
}

# create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefix
}

# create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

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