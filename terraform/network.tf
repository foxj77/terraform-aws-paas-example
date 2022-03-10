
resource "azurerm_virtual_network" "snapvideo" {
  name                = "snapvideoNetwork"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "web" {
  name                 = "webSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.snapvideo.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.snapvideo]

}

resource "azurerm_subnet" "backend" {
  name                 = "backendSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.snapvideo.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.snapvideo]
}

resource "azurerm_subnet" "database" {
  name                 = "databaseSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.snapvideo.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
  depends_on = [azurerm_virtual_network.snapvideo]
}

resource "azurerm_lb" "backend" {
  name                = "backendLoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name               = "backendIP"
    subnet_id          = azurerm_subnet.backend.id
    private_ip_address = "10.0.2.240"
  }
}

resource "azurerm_lb_nat_rule" "backend" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.backend.id
  name                           = "backendAccess"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "backendIP"
}

resource "azurerm_network_interface_nat_rule_association" "backend" {
  network_interface_id  = azurerm_network_interface.snapvideobackend.id
  ip_configuration_name = "backendConfiguration"
  nat_rule_id           = azurerm_lb_nat_rule.backend.id
}