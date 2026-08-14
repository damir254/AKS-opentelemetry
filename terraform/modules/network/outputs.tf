output "azurerm_vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the virtual network."
}

output "subnet_ids" {
  value = {
    for k, v in azurerm_subnet.this : k => v.id
  }
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the virtual network."
}
