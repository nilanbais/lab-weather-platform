output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "Storage account name"
}

output "filesystem_names" {
  value       = sort(tolist(var.filesystems))
  description = "Created filesystems (containers)"
}
