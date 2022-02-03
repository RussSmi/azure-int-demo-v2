locals {
  apim_policy_path = format("%s%s", var.apim_policies_path, "apim_policy.xml")
}

resource "azurerm_resource_group" "apim" {
  name     = "${var.resource_group_name}-apim-${lower(var.environment)}"
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_application_insights" "apim" {
  name                = "apimappinsights${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.apim.name
  application_type    = "web"

  retention_in_days   = 90
  sampling_percentage = 0
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_api_management" "apim" {
  name                = "apim-ais-demo-${lower(var.environment)}"
  location            = var.location
  resource_group_name = azurerm_resource_group.apim.name

  notification_sender_email = "apimgmt-noreply@mail.windowsazure.com"
  policy {
    xml_content = file(local.apim_policy_path)
  }

  publisher_email      = "russell.smith@microsoft.com"
  publisher_name       = "Demo"
  sku_name             = "Developer_1"
  tags                 = var.tags
  virtual_network_type = "None"

  identity {
    type = "SystemAssigned"
  }

  hostname_configuration {
    proxy {
      default_ssl_binding          = true
      host_name                    = "apim-ais-demo-${lower(var.environment)}.azure-api.net"
      negotiate_client_certificate = true
    }
  }

  lifecycle {
    ignore_changes = [
      tags, policy.0.xml_content, hostname_configuration,
    ]
  }
}