resource "azurerm_mysql_flexible_server" "snapvideo" {
  name                   = "snapvideo-mysql"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "snapvideoMysqladmin"
  administrator_password = azurerm_key_vault_secret.databasepassword.value
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.database.id
  private_dns_zone_id    = azurerm_private_dns_zone.snapvideo.id
  sku_name               = "GP_Standard_D2ds_v4"

  high_availability {
    mode = "ZoneRedundant"
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.snapvideo, azurerm_subnet.database,azurerm_key_vault.kv]
}
