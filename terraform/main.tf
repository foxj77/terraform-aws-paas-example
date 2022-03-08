terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.customer}-${var.prefix}"
  location = var.location

    tags = {
    "environment"  = "client demo"
    "productowner" = "JohnFox"
  } 
}

module "network" {
  source                      = "./modules/network"
  environment                 = var.prefix
  customer                    = var.customer
  project                     = var.project
  resource_group_name         = azurerm_resource_group.rg.name
  subnet_cidr                 = var.subnet_cidr
  address_space               = var.address_space
  location                    = var.location
  az                          = var.az
  nat_gateway_id              = module.nat-gateway.nat_gateway_id
  network_security_group_name = module.nsg.network_security_group_name
  network_security_group_id   = module.nsg.network_security_group_id
}

module "nsg" {
  source              = "./modules/nsg"
  environment         = var.prefix
  customer            = var.customer
  project             = var.project
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  az                  = var.az
}

module "nat-gateway" {
  source              = "./modules/nat-gateway"
  environment         = var.prefix
  customer            = var.customer
  project             = var.project
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  az                  = var.az
}
