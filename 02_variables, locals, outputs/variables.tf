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
  default = "aks-terraform"
}

variable "dns_prefix" {
  type = string
}

variable "orchestrator_version" {
  type        = string
  description = "If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)"
}

variable "cluster_sku_tier" {
  type = string
}


############################# default node pool #############################
variable "default_node_pool_name" {
  type        = string
  description = "Max. 12 characters and must start with lowerletters (a-z0-9)"
}

variable "default_node_pool_vm_size" {
  type = string
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
  type = number
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
variable "acr_name" {
  type        = string
  description = "Azure Container Registry for storing container images"
}

variable "acr_sku" {
  type = string
}

