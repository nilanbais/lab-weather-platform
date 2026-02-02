variable "name" {
  type        = string
  description = "Storage account name (globally unique, 3-24 chars, lowercase/numbers only)"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy the storage account into"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tags" {
  type        = map(string)
  description = "Standard tags applied to all resources"
}

variable "filesystems" {
  type        = set(string)
  description = "ADLS Gen2 filesystems to create (containers)."
  default     = ["bronze", "silver", "gold"]
}
