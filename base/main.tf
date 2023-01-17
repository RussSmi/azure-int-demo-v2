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
  backend "azurerm" {}
}

resource "azurerm_resource_group" "base" {
  name     = "${var.resource_group_name}-base-${lower(var.environment)}"
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "Default-LogAnalytics-${lower(var.environment)}"
  location            = var.location
  resource_group_name = azurerm_resource_group.base.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "log_analytics_id" {
  value = azurerm_log_analytics_workspace.log_analytics.id
}

output "log_analytics_wid" {
  value = azurerm_log_analytics_workspace.log_analytics.workspace_id
}

output "log_analytics_wkey" {
  value     = azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  sensitive = true
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "keyvault" {
  resource_group_name = azurerm_resource_group.base.name
  location            = var.location
  name                = "${var.key_vault_name}${lower(var.environment)}"
  tags                = var.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id


  enable_rbac_authorization       = false
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false
  sku_name                        = "standard"

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  timeouts {}
}

resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                           = "${azurerm_key_vault.keyvault.name}-diags"
  target_resource_id             = azurerm_key_vault.keyvault.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_destination_type = "Dedicated"

  log {
    category = "AuditEvent"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "random_password" "passwords" {
  count   = length(var.pwdsecrets)
  length  = 16
  special = true
}


resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.client_id

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "ManageIssuers",
    "GetIssuers",
    "ListIssuers",
    "SetIssuers",
    "DeleteIssuers",
    "Purge",
  ]
  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Decrypt",
    "Encrypt",
    "UnwrapKey",
    "WrapKey",
    "Verify",
    "Sign",
    "Purge",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge",
  ]

  lifecycle {
    ignore_changes = [
      object_id,
    ]
  }
}

resource "azurerm_key_vault_access_policy" "list" {
  for_each     = toset(var.object-ids)
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = each.key

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "ManageIssuers",
    "GetIssuers",
    "ListIssuers",
    "SetIssuers",
    "DeleteIssuers",
    "Purge",
  ]
  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Decrypt",
    "Encrypt",
    "UnwrapKey",
    "WrapKey",
    "Verify",
    "Sign",
    "Purge",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge",
  ]
}

resource "azurerm_key_vault_secret" "pwds" {
  for_each     = toset(var.pwdsecrets)
  name         = each.key
  value        = random_password.passwords[index(var.pwdsecrets, each.key)].result
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [
    azurerm_key_vault_access_policy.list,
  ]
}


