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

resource "azurerm_storage_account" "lappv2" {
  resource_group_name       = azurerm_resource_group.lareceive.name
  account_kind              = "Storage"
  account_replication_type  = "LRS"
  account_tier              = "Standard"
  allow_blob_public_access  = false
  enable_https_traffic_only = true
  location                  = var.location
  name                      = "lappaisdemo${lower(var.environment)}"
  tags                      = var.tags

  network_rules {
    bypass = [
      "AzureServices",
    ]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

resource "azurerm_application_insights" "lappv2" {
  application_type    = "web"
  location            = var.location
  name                = "lappaisdemo${lower(var.environment)}"
  resource_group_name = azurerm_resource_group.lareceive.name
  tags                = var.tags
}

resource "azurerm_app_service_plan" "lappv2" {
  is_xenon                     = false
  kind                         = "app"
  location                     = var.location
  maximum_elastic_worker_count = 1
  name                         = "lappaisdemo${lower(var.environment)}"
  per_site_scaling             = false
  reserved                     = false
  resource_group_name          = azurerm_resource_group.lareceive.name
  tags                         = var.tags

  sku {
    capacity = 0
    size     = "F1"
    tier     = "Free"
  }
}

resource "azurerm_app_service" "lappv2" {
  app_service_plan_id = azurerm_app_service_plan.lappv2.id
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"           = azurerm_application_insights.lappv2.instrumentation_key
    "AzureWebJobsStorage"                      = azurerm_storage_account.lappv2.primary_connection_string
    "FUNCTIONS_EXTENSION_VERSION"              = "~3"
    "FUNCTIONS_V2_COMPATIBILITY_MODE"          = "true"
    "FUNCTIONS_WORKER_RUNTIME"                 = "node"
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = azurerm_storage_account.lappv2.primary_connection_string
    "WEBSITE_CONTENTSHARE"                     = "lapp-ais-demo-${lower(var.environment)}5e03ef"
    "WEBSITE_NODE_DEFAULT_VERSION"             = "~12"
    "WORKFLOWS_LOCATION_NAME"                  = var.location
    "WORKFLOWS_RESOURCE_GROUP_NAME"            = azurerm_resource_group.lareceive.name
    "WORKFLOWS_SUBSCRIPTION_ID"                = data.azurerm_client_config.current.subscription_id
    "WORKFLOWS_TENANT_ID"                      = data.azurerm_client_config.current.tenant_id
    "Workflows.WebhookRedirectHostUri"         = ""
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE"          = "true"
    "WEBSITE_RUN_FROM_PACKAGE"                 = "1"
    "serviceBus-connectionString"              = "SBCONN"
  }
  enabled             = true
  https_only          = true
  location            = var.location
  name                = "lapp-ais-demo-${lower(var.environment)}"
  resource_group_name = azurerm_resource_group.lareceive.name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      app_settings,
    ]
  }
}