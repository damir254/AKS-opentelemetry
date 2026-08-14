variable "name" {
  description = "Name of the Azure Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which to create the registry."
  type        = string
}

variable "location" {
  description = "Azure region in which to create the registry."
  type        = string
}

variable "sku" {
  description = "SKU of the Azure Container Registry."
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Tags to apply to the registry."
  type        = map(string)
  default     = {}
}
