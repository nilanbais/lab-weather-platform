resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "datalake" {
  source = "../../modules/datalake"

  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags

  filesystems = ["bronze", "silver", "gold"]
}
