output "github_actions_client_id" {
  value = azurerm_user_assigned_identity.github_actions.client_id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "argocd_image_updater_client_id" {
  value = azurerm_user_assigned_identity.argocd_image_updater.client_id
}