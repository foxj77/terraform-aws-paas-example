resource "azurerm_storage_account" "mongodb_storage_account" {
  name                     = "sa${var.project}${var.environment}${var.az}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = "LRS"

  tags = {
    "Environment" = "sa-${var.project}-${var.customer}-${var.environment}-${var.az}"
  }

}

resource "azurerm_storage_container" "mongodb_container" {
  count                 = length(var.container_name)
  name                  = var.container_name[count.index]
  storage_account_name  = azurerm_storage_account.mongodb_storage_account.name
  container_access_type = "private"
}
