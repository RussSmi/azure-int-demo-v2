variable "rgname" {
  type        = string
  description = "The base resource group name, change this for a new environment"
  default     = "rg-tfstate-uks"
}

variable "location" {
  type        = string
  description = "Azure region to use"
  default     = "uksouth"
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default     = { Application = "Azure Integration Services Demo", Environment = "shared", Keep = "Yes" }
}

variable "prefix" {
  type    = string
  default = "ais"
}

variable "environment" {
  type = string
}


resource "azurerm_resource_group" "state" {
  name     = var.rgname
  location = var.location
  tags     = var.tags
}

/*
data "azurerm_resource_group" "state" {
  name = var.rgname
}*/

resource "azurerm_storage_account" "state" {
  name                     = "sa${lower(var.prefix)}tfstate808shared" #Change this for the next environment, SA names must be unique
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  account_kind             = "StorageV2"
  allow_blob_public_access = "true"
}

#Create a container for each environment
resource "azurerm_storage_container" "base" {
  name                  = "${var.prefix}tfstateinfra-base"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"
}

#Create a container for each environment
resource "azurerm_storage_container" "non-prod" {
  name                  = "${var.prefix}tfstateinfra-non-prod"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"
}

#Create a container for each environment
resource "azurerm_storage_container" "prod" {
  name                  = "${var.prefix}tfstateinfra-prod"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"
}

#Create a container for each environment
/*resource "azurerm_storage_container" "shared" {
  name                  = "${var.prefix}tfstateinfra-shared"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"
}*/



