output "id" {
  description = "The ID of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.id
}

output "name" {
  description = "The name of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.name
}

output "nic_id" {
  description = "The ID of the Network Interface."
  value       = azurerm_network_interface.this.id
}

output "private_ip_address" {
  description = "The private IP address assigned to the VM."
  value       = azurerm_network_interface.this.private_ip_address
}

output "public_ip_address" {
  description = "The public IP address assigned to the VM."
  value       = var.enable_public_ip ? azurerm_public_ip.this[0].ip_address : null
}

