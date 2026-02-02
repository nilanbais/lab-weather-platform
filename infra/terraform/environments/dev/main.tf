resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

data "azurerm_client_config" "current" {}

module "keyvault" {
  source = "../../modules/keyvault"

  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = var.tags
}

module "datalake" {
  source = "../../modules/datalake"

  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags

  filesystems = ["bronze", "silver", "gold"]
}
