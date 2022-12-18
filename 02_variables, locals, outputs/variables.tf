############################# resource group #############################
variable "resource_group" {
  type = string
  validation {
    condition     = length(var.resource_group) > 6 && substr(var.resource_group, 0, 3) == "rg-"
    error_message = "The resource group name must be at least 6 characters long and start with rg-."
  }
}

variable "location" {
  type = string
  validation {
    condition     = (var.location == "westeurope" || var.location == "northeurope" || var.location == "germanywestcentral")
    error_message = "The location must be one of West Europe, North Europe, or Germany West Central."
  }
}

############################# main cluster #############################
variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "role_based_access_control_enabled" {
  type    = bool
  default = true
}

variable "cluster_sku_tier" {
  type    = string
  default = "Paid"
}


############################# default node pool #############################
variable "kubernetes_cluster_default_node_pool" {
  type = map(object({
    name                 = string
    vm_size              = string
    enable_auto_scaling  = bool
    min_count            = number
    max_count            = number
    max_pods             = number
    os_disk_size_gb      = number
    os_disk_type         = string
    os_sku               = string
    orchestrator_version = string
    zones                = list(string)
  }))
  default = {
    workload = {
      enable_auto_scaling  = true
      os_sku               = "Ubuntu"
      os_disk_type         = "Managed"
      zones                = ["1", "2", "3"]
      name                 = "defaultnode"
      vm_size              = "Standard_D2_v2"
      min_count            = 1
      max_count            = 3
      max_pods             = 30
      os_disk_size_gb      = 30
      orchestrator_version = null
    }
  }
}


############################ create an azure container registry (acr) #############################
variable "acr_sku" {
  type    = string
  default = "Standard"
}

############################ create a storage account #############################
variable "account_tier" {
  type = string
}

variable "account_replication_type" {
  type = string
}

