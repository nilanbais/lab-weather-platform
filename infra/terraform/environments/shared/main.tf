resource "azurerm_resource_group" "shared" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "acr" {
  source              = "../../modules/acr"
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.shared.name
  location            = var.location
  sku                 = "Basic"
  tags                = var.tags
}
