resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  sku_name = "standard"

  # Default (modern): use RBAC rather than access policies
  enable_rbac_authorization = true

  # Practicum-friendly defaults:
  # - purge protection OFF so you can easily recreate the vault if needed
  # - short soft-delete retention
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  tags = var.tags
}
