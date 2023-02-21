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

resource "azurerm_storage_account" "la-storage" {
  name                            = "laaisdemostrg2${lower(var.environment)}"
  resource_group_name             = azurerm_resource_group.lareceive.name
  location                        = azurerm_resource_group.lareceive.location
  account_kind                    = "Storage"
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  min_tls_version                 = "TLS1_0"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

resource "azurerm_service_plan" "la-plan" {
  name                         = "lappst-plan-ais-demo-${var.environment}"
  resource_group_name          = azurerm_resource_group.lareceive.name
  location                     = azurerm_resource_group.lareceive.location
  maximum_elastic_worker_count = 1
  os_type                      = "Windows"
  sku_name                     = "WS1"
  tags                         = var.tags
  worker_count                 = 1
  zone_balancing_enabled       = false
}

resource "azurerm_application_insights" "la-appins" {
  name                = "app-ins-lappst-${lower(var.environment)}"
  resource_group_name = azurerm_resource_group.lareceive.name
  location            = azurerm_resource_group.lareceive.location
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  application_type    = "web"

  tags = var.tags
}

output "instrumentation_key" {
  sensitive = true
  value     = azurerm_application_insights.la-appins.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.la-appins.app_id
}

resource "azurerm_logic_app_standard" "la-standard" {
  name                       = "lapp-aisdemo-${var.environment}"
  resource_group_name        = azurerm_resource_group.lareceive.name
  location                   = azurerm_resource_group.lareceive.location
  app_service_plan_id        = azurerm_service_plan.la-plan.id
  storage_account_name       = azurerm_storage_account.la-storage.name
  storage_account_access_key = azurerm_storage_account.la-storage.primary_access_key
  version                    = "~4"
  use_extension_bundle       = true
  tags                       = var.tags

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" : azurerm_application_insights.la-appins.instrumentation_key
    "AzureWebJobsStorage" : azurerm_storage_account.la-storage.primary_connection_string
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" : azurerm_storage_account.la-storage.primary_connection_string
    "FUNCTIONS_EXTENSION_VERSION" : "~3"
    "FUNCTIONS_WORKER_RUNTIME" : "node"
    "WEBSITE_CONTENTSHARE" : "lapp-aisdemo-${var.environment}5e03ef"
    "WEBSITE_NODE_DEFAULT_VERSION" : "~14"
    "WORKFLOWS_LOCATION_NAME" : azurerm_resource_group.lareceive.location
    "WORKFLOWS_RESOURCE_GROUP_NAME" : azurerm_resource_group.lareceive.name
    "Workflows.WebhookRedirectHostUri" : ""
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" : "true"
    "WEBSITE_RUN_FROM_PACKAGE" : "1"
    "serviceBus_connectionString" : azurerm_servicebus_namespace.sbus.default_primary_connection_string
    "AzureBlob_connectionString" : azurerm_storage_account.storage.primary_connection_string
  }
}

