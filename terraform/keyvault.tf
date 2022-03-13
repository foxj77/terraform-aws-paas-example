data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "snapVideoKeyVault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "list",
      "create",
    ]

    secret_permissions = [
      "Get",
      "list",
      "set",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

#Create KeyVault VM password
resource "random_password" "webpassword" {
  length  = 20
  special = true
}
#Create Key Vault Secret
resource "azurerm_key_vault_secret" "webpassword" {
  name         = "webPassword"
  value        = random_password.webpassword.result
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault.kv]
}

#Create KeyVault VM password
resource "random_password" "backendpassword" {
  length  = 20
  special = true
}
#Create Key Vault Secret
resource "azurerm_key_vault_secret" "backendpassword" {
  name         = "backendPassword"
  value        = random_password.backendpassword.result
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault.kv]
}

#Create KeyVault VM password
resource "random_password" "databasepassword" {
  length  = 20
  special = true
}
#Create Key Vault Secret
resource "azurerm_key_vault_secret" "databasepassword" {
  name         = "databasePassword"
  value        = random_password.databasepassword.result
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault.kv]
}