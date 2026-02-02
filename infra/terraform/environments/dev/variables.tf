variable "location" {
  type        = string
  description = "Azure region for the environment"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the environment"
}

variable "tags" {
  type        = map(string)
  description = "Standard tags applied to all resources in this environment"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name for this environment (must be globally unique)"
}
