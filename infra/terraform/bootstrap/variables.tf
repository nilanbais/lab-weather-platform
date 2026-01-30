variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for Terraform remote state"
}

variable "storage_account_name" {
  type        = string
  description = "Globally unique storage account name (lowercase, 3-24 chars)"
}

variable "container_name" {
  type        = string
  description = "Blob container name for tfstate"
  default     = "tfstate"
}

variable "tags" {
  type        = map(string)
  description = "Standard tags"
}
