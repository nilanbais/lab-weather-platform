variable "name" {
  type        = string
  description = "Key Vault name (3-24 chars; alphanumeric and hyphens; globally unique)"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy the storage account into"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant id"
}

variable "tags" {
  type        = map(string)
  description = "Standard tags applied to all resources"
}
