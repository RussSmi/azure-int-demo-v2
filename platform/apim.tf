locals {
    apim_post_op_policy_path = format("%s%s", var.apim_policies_path, "op_post_policy.xml")
}
data "azurerm_api_management" "apim" {
  name                = "apim-aisdemo-${lower(var.environment)}"
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


  xml_content = file(local.apim_post_op_policy_path)

}