output "id" {
  value       = azurerm_container_registry.this.id
  description = "ACR resource id"
}

output "login_server" {
  value       = azurerm_container_registry.this.login_server
  description = "ACR login server (e.g. <name>.azurecr.io)"
}

output "name" {
  value       = azurerm_container_registry.this.name
  description = "ACR name"
}
