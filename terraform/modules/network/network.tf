resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project}-${var.customer}-${var.environment}-${var.az}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.project}-${var.customer}-${var.environment}-${var.az}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_cidr]
}
