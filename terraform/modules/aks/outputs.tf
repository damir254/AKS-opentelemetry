output "id" {
  description = "The ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "fqdn" {
  description = "The FQDN of the AKS API server."
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "node_resource_group" {
  description = "The automatically created node resource group."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "kubelet_identity" {
  description = "The kubelet managed identity."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}

output "log_analytics_workspace_id" {
  value       = var.enable_log_analytics ? azurerm_log_analytics_workspace.this[0].id : null
  description = "Log Analytics Workspace ID."
}

output "log_analytics_workspace_name" {
  value       = var.enable_log_analytics ? azurerm_log_analytics_workspace.this[0].name : null
  description = "Log Analytics Workspace name."
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}