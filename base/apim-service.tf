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
    xml_content = <<XML
                <!--
                    IMPORTANT:
                    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.
                    - Only the <forward-request> policy element can appear within the <backend> section element.
                    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.
                    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.
                    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.
                    - To remove a policy, delete the corresponding policy statement from the policy document.
                    - Policies are applied in the order of their appearance, from the top down.
                -->
                <policies>
                        <inbound />
                        <backend>
                                <forward-request />
                        </backend>
                        <outbound />
                </policies>
            XML
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