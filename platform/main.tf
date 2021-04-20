terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.53.0"
    }
    random = {
      version = "~> 2.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.2.2"
    }
  }
  backend "azurerm" {}
  #required_version = "= 0.14.8"
}

