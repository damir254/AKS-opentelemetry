resource "azurerm_log_analytics_workspace" "this" {
  count = var.enable_log_analytics && var.log_analytics_workspace_id == null ? 1 : 0

  name                = "${var.name}-log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_in_days

  tags = var.tags
}

resource "azurerm_monitor_workspace" "this" {
  count = var.enable_managed_prometheus && var.monitor_workspace_id == null ? 1 : 0

  name                = "${var.name}-monitor"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}






resource "azurerm_kubernetes_cluster" "this" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.dns_prefix
  kubernetes_version        = var.kubernetes_version
  sku_tier                  = var.sku_tier
  private_cluster_enabled   = var.private_cluster_enabled
  automatic_upgrade_channel = var.automatic_upgrade_channel
  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.enable_key_vault_provider ? [1] : []

    content {
      secret_rotation_enabled = true
    }
  }



  default_node_pool {
    name = "system"

    vm_size = var.vm_size

    node_count           = var.enable_auto_scaling ? null : var.node_count
    max_pods             = var.max_pods
    auto_scaling_enabled = var.enable_auto_scaling

    min_count = var.enable_auto_scaling ? var.min_count : null
    max_count = var.enable_auto_scaling ? var.max_count : null

    vnet_subnet_id = var.subnet_id

    type = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  local_account_disabled = var.disable_local_accounts

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.enable_azure_rbac
    admin_group_object_ids = var.admin_group_object_ids
  }

  tags = var.tags

  network_profile {
  network_plugin    = "azure"
  network_data_plane = "cilium"

  load_balancer_sku = "standard"
  service_cidr      = var.service_cidr
  dns_service_ip    = var.dns_service_ip
  }

  dynamic "oms_agent" {
    for_each = var.enable_log_analytics ? [1] : []

    content {
      log_analytics_workspace_id = (
        var.log_analytics_workspace_id != null
        ? var.log_analytics_workspace_id
        : azurerm_log_analytics_workspace.this[0].id
      )
    }
  }

  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_interval_hours

}


resource "azurerm_kubernetes_cluster_node_pool" "this" {

  for_each = var.node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vm_size = each.value.vm_size

  mode = each.value.mode

  node_count = each.value.enable_auto_scaling ? null : each.value.node_count

  auto_scaling_enabled = each.value.enable_auto_scaling

  min_count = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count = each.value.enable_auto_scaling ? each.value.max_count : null

  os_disk_size_gb = each.value.os_disk_size_gb

  node_labels = each.value.node_labels

  node_taints = each.value.node_taints

  vnet_subnet_id = var.subnet_id

  tags = var.tags
}

locals {
  monitor_workspace_id = var.enable_managed_prometheus ? coalesce(
    var.monitor_workspace_id,
    one(azurerm_monitor_workspace.this[*].id)
  ) : null
}

resource "azurerm_kubernetes_cluster_extension" "azure_monitor_metrics" {
  count = var.enable_managed_prometheus ? 1 : 0

  name           = "azuremonitor-metrics"
  cluster_id     = azurerm_kubernetes_cluster.this.id
  extension_type = "Microsoft.AzureMonitor.Containers.Metrics"

  configuration_settings = {
    azure-monitor-workspace-resource-id = local.monitor_workspace_id
  }
}

resource "azurerm_dashboard_grafana" "this" {
  count = var.enable_managed_prometheus ? 1 : 0

  name                = "${var.name}-grafana"
  location            = var.location
  resource_group_name = var.resource_group_name

  grafana_major_version = "12"

  identity {
    type = "SystemAssigned"
  }

  api_key_enabled = true

  tags = var.tags
}

resource "azurerm_role_assignment" "grafana_monitor_reader" {
  count = var.enable_managed_prometheus ? 1 : 0

  scope                = local.monitor_workspace_id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = azurerm_dashboard_grafana.this[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_metrics_publisher" {
  count = var.enable_managed_prometheus ? 1 : 0

  scope                = local.monitor_workspace_id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "grafana_reader_subscription" {
  count = var.enable_managed_prometheus ? 1 : 0

  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azurerm_dashboard_grafana.this[0].identity[0].principal_id
}

data "azurerm_subscription" "current" {}

resource "azapi_update_resource" "gateway_api" {
  count = var.enable_gateway_api ? 1 : 0

  type        = "Microsoft.ContainerService/managedClusters@2026-04-01"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = {
    properties = {
      ingressProfile = {
        gatewayAPI = {
          installation = "Standard"
        }

        webAppRouting = {
          gatewayAPIImplementations = {
            appRoutingIstio = {
              mode = "Enabled"
            }
          }
        }
      }
    }
  }
}