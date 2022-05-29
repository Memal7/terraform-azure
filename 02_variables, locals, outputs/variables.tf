variable "resource_group" {
  type = string
}

variable "location" {
  type = string
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
}

variable "subnet_name" {
  type = string
}

variable "subnet_prefix" {
  type = list(string)
}

variable "nsg_name" {
  type = string
}