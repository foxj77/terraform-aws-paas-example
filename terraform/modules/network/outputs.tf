output "aks_subnet_id" {
  value = azurerm_subnet.subnet.id
}
output "aks_vnet_id" {
  value = azurerm_virtual_network.main.id
}

#output "public_ip" {
#  value = azurerm_public_ip.public_ingress.ip_address
#}
