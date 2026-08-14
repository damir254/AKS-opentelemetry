variable "name" {
  description = "The name of the resource."
  type        = string
}

variable "location" {
  description = "The Azure region where the resource will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resource."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet in which to create the network interface."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_D4s_v3"
}

variable "min_count" {
  description = "The minimum number of nodes in the virtual machine scale set."
  type        = number
}


variable "max_count" {
  description = "The maximum number of nodes in the virtual machine scale set."
  type        = number
}

variable "node_count" {
  description = "The number of nodes in the virtual machine scale set."
  type        = number
}


variable "enable_auto_scaling" {
  description = "Whether to enable auto-scaling for the virtual machine scale set."
  type        = bool
  default     = false
}

variable "dns_prefix" {
  description = "The DNS prefix for the public IP address."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the virtual machine scale set."
  type        = string
}

variable "sku_tier" {
  description = "The SKU tier for the AKS cluster."
  type        = string
  default     = "Free"
}


variable "private_cluster_enabled" {
  description = "Whether to enable private cluster for the AKS cluster."
  type        = bool
  default     = false
}

variable "automatic_upgrade_channel" {
  description = "The automatic upgrade channel for the AKS cluster."
  type        = string
  default     = "stable"
}

variable "log_analytics_retention_in_days" {
  description = "The number of days to retain data in the Log Analytics workspace."
  type        = number
  default     = 30
}

variable "enable_log_analytics" {
  description = "Whether to enable Log Analytics for the AKS cluster."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "oidc_issuer_enabled" {
  description = "Whether to enable OIDC issuer for the AKS cluster."
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Whether to enable workload identity for the AKS cluster."
  type        = bool
  default     = true
}

variable "enable_key_vault_provider" {
  type    = bool
  default = true
}

variable "image_cleaner_enabled" {
  description = "Whether to enable the image cleaner for the AKS cluster."
  type        = bool
  default     = true
}

variable "image_cleaner_interval_hours" {
  description = "The interval for the image cleaner to run."
  type        = number
  default     = 72

}

variable "local_account_disabled" {
  description = "Whether to disable local accounts for the AKS cluster."
  type        = bool
  default     = false
}

variable "node_pools" {
  description = "Additional AKS node pools."

  type = map(object({
    vm_size             = string
    node_count          = optional(number)
    enable_auto_scaling = optional(bool, false)
    min_count           = optional(number)
    max_count           = optional(number)
    os_disk_size_gb     = optional(number, 128)
    mode                = optional(string, "User")
    node_labels         = optional(map(string), {})
    node_taints         = optional(list(string), [])
  }))

  default = {}
}

variable "secret_rotation_enabled" {
  description = "Whether to enable secret rotation for the AKS cluster."
  type        = bool
  default     = true
}

variable "service_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "dns_service_ip" {
  type    = string
  default = "10.100.0.10"
}

variable "enable_azure_rbac" {
  description = "Enable Azure RBAC for Kubernetes authorization."
  type        = bool
  default     = true
}

variable "disable_local_accounts" {
  description = "Disable local Kubernetes admin accounts."
  type        = bool
  default     = true
}

variable "admin_group_object_ids" {
  description = "Microsoft Entra group object IDs that should have AKS administrator access."
  type        = list(string)
  default     = []
}

variable "enable_managed_prometheus" {
  description = "Enable Azure Managed Prometheus."
  type        = bool
  default     = true
}

variable "monitor_workspace_id" {
  description = "Existing Azure Monitor Workspace ID."
  type        = string
  default     = null
}

variable "max_pods" {
  description = "The maximum number of pods that can run on a node."
  type        = number
  default     = 110
}

variable "enable_gateway_api" {
  description = "Enable AKS-managed Gateway API CRDs and the AKS Application Routing Istio Gateway API implementation."
  type        = bool
  default     = false
}