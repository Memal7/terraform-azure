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
  type    = string
  default = "defaultaks01"
}

variable "dns_prefix" {
  type = string
}

variable "role_based_access_control_enabled" {
  type    = bool
  default = true
}

variable "orchestrator_version" {
  type        = string
  description = "If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)"
}

variable "cluster_sku_tier" {
  type    = string
  default = "Paid"
}


############################# default node pool #############################
variable "default_node_pool_name" {
  type        = string
  description = "Max. 12 characters and must start with lowerletters (a-z0-9)"
}

variable "default_node_pool_vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

variable "enable_auto_scaling" {
  type    = bool
  default = true
}

variable "default_node_pool_min_count" {
  type    = number
  default = 1
}

variable "default_node_pool_max_count" {
  type    = number
  default = 3
}

variable "default_node_pool_max_pods" {
  type    = number
  default = 30
}

variable "default_node_pool_os_disk_size_gb" {
  type    = number
  default = 30
}

variable "default_node_pool_os_disk_type" {
  type    = string
  default = "Managed"
}

variable "default_node_pool_os_sku" {
  type    = string
  default = "Ubuntu"
}

variable "default_node_pool_availability_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
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

