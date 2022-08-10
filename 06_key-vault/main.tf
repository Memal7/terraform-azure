data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "West Europe"
}

# Locals
locals {
  keyvault_name = "kv-${random_integer.random.result}"
}

# create random integer for random name
resource "random_integer" "random" {
  min = 10000
  max = 99999
}

data "azuread_client_config" "current" {}

resource "azuread_application" "example1" {
  display_name = "example1"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "example1" {
  application_id               = azuread_application.example1.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "example1" {
  service_principal_id = azuread_service_principal.example1.object_id
}

resource "azurerm_key_vault_secret" "example1" {
  name         = "example1"
  value        = azuread_service_principal_password.example1.value
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azuread_application" "example2" {
  display_name = "example2"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "example2" {
  application_id               = azuread_application.example2.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "example2" {
  service_principal_id = azuread_service_principal.example2.object_id
}

resource "azurerm_key_vault_secret" "example2" {
  name         = "example2"
  value        = azuread_service_principal_password.example2.value
  key_vault_id = azurerm_key_vault.kv.id
}

# create key vault
resource "azurerm_key_vault" "kv" {
  name                       = local.keyvault_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "SetIssuers",
      "Update",
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set",
    ]
  }
}

resource "azurerm_key_vault_certificate" "kv-cert" {
  name         = "generated-cert"
  key_vault_id = azurerm_key_vault.kv.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["internal.contoso.com", "domain.hello.world"]
      }

      subject            = "CN=hello-world"
      validity_in_months = 12
    }
  }
}

