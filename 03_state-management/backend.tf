terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stgacc93246"
    container_name       = "terraform-state"
    key                  = "terraform.state"
  }
}