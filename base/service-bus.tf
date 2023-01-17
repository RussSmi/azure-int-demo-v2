resource "azurerm_resource_group" "sbus" {
  name     = "${var.resource_group_name}-sbus-${lower(var.environment)}"
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


resource "azurerm_servicebus_namespace" "sbus" {
  name                = "sbus-ais-demo-${lower(var.environment)}"
  location            = azurerm_resource_group.sbus.location
  resource_group_name = azurerm_resource_group.sbus.name
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}

resource "azurerm_servicebus_topic" "sbus" {
  name                = "sbtopic-ais-demo"
  //resource_group_name = azurerm_resource_group.sbus.name
  namespace_id      = azurerm_servicebus_namespace.sbus.id

  enable_partitioning = true
}

resource "azurerm_servicebus_subscription" "sbus" {
  name                = "sbsubscription-ais-demo"
  //resource_group_name = azurerm_resource_group.sbus.name
  //namespace_id      = azurerm_servicebus_namespace.sbus.id
  topic_id          = azurerm_servicebus_topic.sbus.id
  max_delivery_count  = 1
}