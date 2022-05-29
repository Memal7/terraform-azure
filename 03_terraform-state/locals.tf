locals {
  # create locals for tags 
  tags = {
    creator = "mustafa emal"
    purpose = "test terraform with Azure"
    env     = "dev"
  }

  storage_name = "stgacc${random_integer.random.result}"
}

# create random integer for random name
resource "random_integer" "random" {
  min = 10000
  max = 99999
}

# Local file
resource "local_file" "post-config" {
  depends_on = [azurerm_storage_container.container]

  filename = "${path.module}/backend-config.txt"
  content  = <<EOF
storage_account_name = "${azurerm_storage_account.storage.name}"
container_name = "terraform-state"
key = "terraform.tfstate"
sas_token = "${data.azurerm_storage_account_sas.state.sas}"
  EOF
}