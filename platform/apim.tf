data "azurerm_api_management" "apim" {
  name                = "apim-ais-demo-${lower(var.environment)}"
  resource_group_name = "${var.resource_group_name}-apim-${lower(var.environment)}"
}

resource "azurerm_api_management_api" "apim" {
  display_name        = "publish"
  name                = "publish"
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
  path                = "external"
  revision            = "1"
  service_url         = var.la-receive-url
  soap_pass_through   = false

  protocols = [
    "https",
  ]

  subscription_key_parameter_names {
    header = "Ocp-Apim-Subscription-Key"
    query  = "subscription-key"
  }
  /*lifecycle {
    ignore_changes = [
      service_url,
    ]
  }*/
}

resource "azurerm_api_management_api_operation" "apim-post" {
  api_name            = azurerm_api_management_api.apim.name
  api_management_name = azurerm_api_management_api.apim.api_management_name
  resource_group_name = azurerm_api_management_api.apim.resource_group_name
  display_name        = "POST"
  method              = "POST"
  operation_id        = "POST"
  url_template        = "/"

  request {
    query_parameter {
      description = "Generic value to enable internal routing"
      name        = "target"
      required    = false
      type        = "string"
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "apim-post" {
  api_name            = azurerm_api_management_api_operation.apim-post.api_name
  api_management_name = azurerm_api_management_api_operation.apim-post.api_management_name
  resource_group_name = azurerm_api_management_api_operation.apim-post.resource_group_name
  operation_id        = azurerm_api_management_api_operation.apim-post.operation_id


  xml_content = <<XML
        <!--
            IMPORTANT:
            - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.
            - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.
            - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.
            - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.
            - To remove a policy, delete the corresponding policy statement from the policy document.
            - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.
            - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.
            - Policies are applied in the order of their appearance, from the top down.
            - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.
        -->
<policies>
    <inbound>
        <base />     
        <rate-limit-by-key calls="1" renewal-period="10" counter-key="@(context.Subscription?.Key ?? "anonymous")" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
    XML

}