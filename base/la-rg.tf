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