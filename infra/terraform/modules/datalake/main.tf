resource "azurerm_storage_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Enable ADLS Gen2 (hierarchical namespace)
  is_hns_enabled = true

  # Baseline security
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = var.tags
}

resource "azurerm_storage_container" "fs" {
  for_each              = var.filesystems
  name                  = each.value
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}
