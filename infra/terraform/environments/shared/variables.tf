variable "resource_group_name" {
  type        = string
  description = "Shared resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tags" {
  type        = map(string)
  description = "Standard tags"
  default     = {}
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name"
}
