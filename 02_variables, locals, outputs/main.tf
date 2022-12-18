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

# create an aks cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                              = var.cluster_name
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  dns_prefix                        = var.dns_prefix
  role_based_access_control_enabled = var.role_based_access_control_enabled
  sku_tier                          = var.cluster_sku_tier

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  default_node_pool {
    name                 = var.kubernetes_cluster_default_node_pool.workload.name
    vm_size              = var.kubernetes_cluster_default_node_pool.workload.vm_size
    enable_auto_scaling  = var.kubernetes_cluster_default_node_pool.workload.enable_auto_scaling
    min_count            = var.kubernetes_cluster_default_node_pool.workload.min_count
    max_count            = var.kubernetes_cluster_default_node_pool.workload.max_count
    max_pods             = var.kubernetes_cluster_default_node_pool.workload.max_pods
    os_disk_size_gb      = var.kubernetes_cluster_default_node_pool.workload.os_disk_size_gb
    os_disk_type         = var.kubernetes_cluster_default_node_pool.workload.os_disk_type
    os_sku               = var.kubernetes_cluster_default_node_pool.workload.os_sku
    orchestrator_version = var.kubernetes_cluster_default_node_pool.workload.orchestrator_version
    zones                = var.kubernetes_cluster_default_node_pool.workload.zones

  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

# create an azure container registry (acr)
resource "azurerm_container_registry" "acr" {
  name                   = local.acr_name
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  sku                    = var.acr_sku
  admin_enabled          = false
  anonymous_pull_enabled = false

  tags = local.tags
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
