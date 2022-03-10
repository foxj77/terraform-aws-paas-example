resource "azurerm_mysql_flexible_server" "snapvideo" {
  name                   = "snapvideo-mysql"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "snapvideoMysqladmin"
  administrator_password = "H@Sh1CoR3!"
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.database.id
  private_dns_zone_id    = azurerm_private_dns_zone.snapvideo.id
  sku_name               = "GP_Standard_D2ds_v4"

  high_availability {
    mode = "ZoneRedundant"
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.snapvideo, azurerm_subnet.database]
}

resource "azurerm_mysql_firewall_rule" "snapvideo" {
  name                = "azureAccess"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.snapvideo.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_firewall_rule" "middleware" {
  name                = "middlewareAccess"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.snapvideo.name
  start_ip_address    = "10.0.2.0"
  end_ip_address      = "10.0.2.255"
}

