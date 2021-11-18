terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.58.0"
    }
    random = {
      version = "~> 2.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.2.2"
    }
  }
}

data "azurerm_client_config" "current" {}
resource "azurerm_resource_group" "lareceive" {
  name     = "${var.resource_group_name}-lappsingleten-${lower(var.environment)}"
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}