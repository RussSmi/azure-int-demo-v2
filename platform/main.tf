terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    random = {
      version = ">= 2.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 1.2.2"
    }
  }
}


