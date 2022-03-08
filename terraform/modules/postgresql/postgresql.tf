# Create a Database Password
resource "random_password" "administrator_password" {
  length           = 16
  special          = true
  override_special = "_-"
}

resource "azurerm_postgresql_server" "server" {
  name                = "postgresql-${var.project}-${var.customer}-${var.environment}-${var.az}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.sku_name

  storage_mb                    = var.storage_mb
  backup_retention_days         = var.backup_retention_days
  geo_redundant_backup_enabled  = var.geo_redundant_backup_enabled
  auto_grow_enabled             = false
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_password
  version                       = var.server_version
  ssl_enforcement_enabled       = var.ssl_enforcement_enabled
  public_network_access_enabled = var.public_network_access_enabled

  tags = {
    "Environment" = "postgresql-${var.project}-${var.customer}-${var.environment}-${var.az}"
  }
}

resource "azurerm_postgresql_database" "dbs" {
  count               = length(var.db_names)
  name                = var.db_names[count.index]
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  charset             = var.db_charset
  collation           = var.db_collation
}

resource "azurerm_postgresql_firewall_rule" "example" {
  name                = "azureAccess"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_firewall_rule" "experfyvpn" {
  name                = "experfyVpnAccess"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  start_ip_address    = "149.28.61.65"
  end_ip_address      = "149.28.61.65"
}