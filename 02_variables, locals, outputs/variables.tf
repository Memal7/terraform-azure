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
    condition = (var.location == "westeurope" || var.location == "northeurope" || var.location == "germanywestcentral")
    error_message = "The location must be one of West Europe, North Europe, or Germany West Central."
  }
}

variable "storage_tier" {
  type = string
}

variable "storage_replication_type" {
  type = string
}
  
variable "vnet_name" {
  type = string
}

variable "vnet_space" {
  type = list(string)
  sensitive = true
}

variable "subnet_name" {
  type = string
}

variable "subnet_prefix" {
  type = list(string)
}

variable "nsg_name" {
  type = string
  description = "Network Security Group Name"
}