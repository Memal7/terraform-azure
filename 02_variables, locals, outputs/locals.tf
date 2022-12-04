locals {
  # create locals for commen tags 
  tags = {
    creator     = "mustafa emal"
    purpose     = "have fun with terraform in Azure"
    env         = "dev"
    cost-center = "CSU - AppInno"
  }

  # create a random string for the name of the storage account
  storage_name = "stgacc${random_integer.random.result}"
  acr_name = "acr${random_integer.random.result}"
}

# create random integer for random name
resource "random_integer" "random" {
  min = 10000
  max = 99999
}