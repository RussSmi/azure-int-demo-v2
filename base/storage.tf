resource "azurerm_resource_group" "storage" {
  name     = "${var.resource_group_name}-storage-${lower(var.environment)}"
  location = var.location
  tags     = var.tags


}

resource "azurerm_storage_account" "storage" {
  name                     = "str101aisdemo${lower(var.environment)}"
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  //allow_blob_public_access = "true"
}

resource "azurerm_storage_container" "storage" {

  name                  = "subscriber"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}