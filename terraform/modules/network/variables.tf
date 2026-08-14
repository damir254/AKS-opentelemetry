variable "name" {
  description = "The name of the resource."
  type        = string
}

variable "location" {
  description = "The location of the resource."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network."
  type        = list(string)
}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
