variable "name" {
  type        = string
  description = "ACR name (5-50 chars, lowercase letters and numbers only, globally unique)"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for ACR"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "sku" {
  type        = string
  description = "ACR SKU (Basic/Standard/Premium)"
  default     = "Basic"
}

variable "tags" {
  type        = map(string)
  description = "Standard tags applied to resources"
  default     = {}
}
