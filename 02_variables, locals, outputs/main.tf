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
}

# create an aks cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                              = var.cluster_name
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  dns_prefix                        = var.dns_prefix
  role_based_access_control_enabled = true
  kubernetes_version                = var.orchestrator_version
  sku_tier                          = var.cluster_sku_tier

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  default_node_pool {
    name                 = var.default_node_pool_name
    vm_size              = var.default_node_pool_vm_size
    enable_auto_scaling  = true
    min_count            = var.default_node_pool_min_count
    max_count            = var.default_node_pool_max_count
    max_pods             = var.default_node_pool_max_pods
    os_disk_size_gb      = var.default_node_pool_os_disk_size_gb
    os_disk_type         = var.default_node_pool_os_disk_type
    os_sku               = var.default_node_pool_os_sku
    orchestrator_version = var.orchestrator_version
    zones                = var.default_node_pool_availability_zones

  }

  identity {
    type = "SystemAssigned"
  }
}

# create an azure container registry (acr)
resource "azurerm_container_registry" "acr" {
  name                   = local.acr_name
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  sku                    = var.acr_sku
  admin_enabled          = false
  anonymous_pull_enabled = false
}

# create a storage account
resource "azurerm_storage_account" "storage_account" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = local.tags
}
