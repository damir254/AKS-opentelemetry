
aks_name   = "aks-devops-dev"
dns_prefix = "aks-devops"

kubernetes_version = "1.35.6"


vm_size = "Standard_D4s_v3"

node_count = 1

max_count = 2

min_count = 1

enable_auto_scaling = false

sku_tier = "Free"

private_cluster_enabled = false

automatic_upgrade_channel = "patch"

oidc_issuer_enabled = true

workload_identity_enabled = true

disable_local_accounts = true

enable_azure_rbac = true

admin_group_object_ids = [
  "b8dbb3dd-1997-4bbc-90a0-d962f52b9808"
]


service_cidr = "10.2.0.0/16"

dns_service_ip = "10.2.0.10"


enable_key_vault_provider = false

enable_log_analytics = true

log_analytics_retention_in_days = 30

enable_managed_prometheus = false

image_cleaner_enabled = true

image_cleaner_interval_hours = 48

max_pods = 110

enable_gateway_api = true
