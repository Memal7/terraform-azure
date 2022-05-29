locals {
  tags = {
    creator       = "mustafa emal"
    purpose       = "test terraform with Azure"
    env = "dev"
  }

  storage_name = "stgacc${random_integer.random.result}"
}

# create random integer for random name
resource "random_integer" "random" {
  min = 10000
  max = 99999
}