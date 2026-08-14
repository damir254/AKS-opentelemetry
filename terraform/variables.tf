variable "aks_name" {
  description = "AKS cluster name."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version."
  type        = string
}

variable "vm_size" {
  description = "VM size for the default node pool."
  type        = string
  default     = "Standard_D4s_v3"
}

variable "node_count" {
  description = "Number of nodes in the default node pool."
  type        = number
}

variable "max_count" {
  description = "Maximum number of nodes in the default node pool."
  type        = number
  default     = 2
}

variable "min_count" {
  description = "Minimum number of nodes in the default node pool."
  type        = number
  default     = 1
}

variable "enable_auto_scaling" {
  description = "Enable cluster autoscaler for the default node pool."
  type        = bool
}

variable "sku_tier" {
  description = "AKS SKU tier."
  type        = string
}

variable "private_cluster_enabled" {
  description = "Deploy a private AKS cluster."
  type        = bool
}

variable "automatic_upgrade_channel" {
  description = "Automatic upgrade channel."
  type        = string
}

variable "oidc_issuer_enabled" {
  description = "Enable OIDC issuer."
  type        = bool
}

variable "workload_identity_enabled" {
  description = "Enable Azure Workload Identity."
  type        = bool
}

variable "disable_local_accounts" {
  description = "Disable local Kubernetes accounts."
  type        = bool
}

variable "enable_azure_rbac" {
  description = "Enable Azure RBAC."
  type        = bool
}

variable "admin_group_object_ids" {
  description = "Azure Entra ID admin group object IDs."
  type        = list(string)
}

variable "service_cidr" {
  description = "Service CIDR."
  type        = string
}

variable "dns_service_ip" {
  description = "DNS Service IP."
  type        = string
}

variable "enable_key_vault_provider" {
  description = "Enable Key Vault Secrets Provider."
  type        = bool
}

variable "enable_log_analytics" {
  description = "Enable Log Analytics."
  type        = bool
}

variable "log_analytics_retention_in_days" {
  description = "Log Analytics retention."
  type        = number
}

variable "enable_managed_prometheus" {
  description = "Enable Azure Managed Prometheus."
  type        = bool
}

variable "image_cleaner_enabled" {
  description = "Enable image cleaner."
  type        = bool
}

variable "image_cleaner_interval_hours" {
  description = "Image cleaner interval."
  type        = number
}

variable "max_pods" {
  description = "The maximum number of pods that can run on a node."
  type        = number
  default     = 110
}

variable "enable_gateway_api" {
  description = "Enable AKS-managed Gateway API CRDs and the AKS Application Routing Istio Gateway API implementation."
  type        = bool
  default     = true
}