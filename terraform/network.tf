
resource "azurerm_virtual_network" "snapvideo" {
  name                = "vnet-${var.customer}-${terraform.workspace}-${var.location}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

tags = {
    "environment"  = "client demo"
    "productowner" = "JohnFox"
    "deployedBy"   = "terraformCloud"
  }
}

resource "azurerm_subnet" "aag" {
  name                 = "subnet-aag-${var.customer}-${terraform.workspace}-${var.location}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.snapvideo.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on           = [azurerm_virtual_network.snapvideo]
}

resource "azurerm_subnet" "web" {
  name                 = "subnet-web-${var.customer}-${terraform.workspace}-${var.location}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.snapvideo.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.snapvideo]

}

resource "azurerm_subnet" "backend" {
  name                 = "subnet-backend-${var.customer}-${terraform.workspace}-${var.location}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.snapvideo.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.snapvideo]
}

resource "azurerm_subnet" "database" {
  name                 = "subnet-database-${var.customer}-${terraform.workspace}-${var.location}"
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
  name                = "belb-${var.customer}-${terraform.workspace}-${var.location}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name               = "beip-${var.customer}-${terraform.workspace}-${var.location}"
    subnet_id          = azurerm_subnet.backend.id
    private_ip_address = "10.0.2.240"
  }
}

resource "azurerm_lb_nat_rule" "backend" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.backend.id
  name                           = "belbrule-${var.customer}-${terraform.workspace}-${var.location}"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "backendIP"
}

resource "azurerm_network_interface_nat_rule_association" "backend" {
  network_interface_id  = azurerm_network_interface.snapvideobackend.id
  ip_configuration_name = "internal"
  nat_rule_id           = azurerm_lb_nat_rule.backend.id
}


resource "azurerm_public_ip" "web" {
  name                = "ip-web-${var.customer}-${terraform.workspace}-${var.location}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.snapvideo.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.snapvideo.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.snapvideo.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.snapvideo.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.snapvideo.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.snapvideo.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.snapvideo.name}-rdrcfg"
}

