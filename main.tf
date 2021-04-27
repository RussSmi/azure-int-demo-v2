terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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

data "azurerm_log_analytics_workspace" "ais" {
  name                = "Default-LogAnalytics-${lower(var.environment)}"
  resource_group_name = "${var.resource_group_name}-base-${lower(var.environment)}"
}

module "platform" {
  source                     = "./platform"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.ais.id
  environment                = var.environment
}