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

variable "subnet_id" {
  description = "The ID of the subnet."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_D2as_v6"
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key for the virtual machine."
  type        = string
}

variable "enable_public_ip" {
  description = "Whether to enable a public IP for the virtual machine."
  type        = bool
  default     = false
}

variable "image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  default = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}