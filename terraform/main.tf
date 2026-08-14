terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.11"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {}

resource "azurerm_resource_group" "this" {
  name     = "opentelemetry-demo"
  location = "westeurope"
}


module "acr" {
  source = "./modules/acr"

  name                = "otelDemoAcr"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Basic"

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}


module "network" {

  source = "./modules/network"

  name                = "azure-lab"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  address_space = ["10.0.0.0/16"]

  subnets = {
    aks = {
      address_prefixes = ["10.0.1.0/24"]
    }

  }

  tags = {
    Environment = "dev"
    Project     = "azure-lab"
  }


}

module "aks" {
  source = "./modules/aks"

  name                = var.aks_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dns_prefix         = var.dns_prefix
  kubernetes_version = var.kubernetes_version
  subnet_id          = module.network.subnet_ids["aks"]

  vm_size             = var.vm_size
  node_count          = var.node_count
  max_count           = var.max_count
  min_count           = var.min_count
  enable_auto_scaling = var.enable_auto_scaling
  max_pods            = var.max_pods

  sku_tier                  = var.sku_tier
  private_cluster_enabled   = var.private_cluster_enabled
  automatic_upgrade_channel = var.automatic_upgrade_channel
  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled
  disable_local_accounts    = var.disable_local_accounts
  enable_gateway_api        = var.enable_gateway_api

  enable_azure_rbac      = var.enable_azure_rbac
  admin_group_object_ids = var.admin_group_object_ids

  service_cidr   = var.service_cidr
  dns_service_ip = var.dns_service_ip

  enable_key_vault_provider = var.enable_key_vault_provider

  enable_log_analytics            = var.enable_log_analytics
  log_analytics_retention_in_days = var.log_analytics_retention_in_days
  enable_managed_prometheus       = var.enable_managed_prometheus

  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_interval_hours

  node_pools = {}

  tags = {
    Environment = "dev"
    Project     = "DevOps"
    ManagedBy   = "Terraform"
  }
}

module "key_vault" {
  source = "./modules/key-vault"

  name                = "otel-demo-kv-dev12333"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    Environment = "dev"
    Project     = "DevOps"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_user_assigned_identity" "eso" {
  name                = "eso-identity"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    Environment = "dev"
    Project     = "azure-lab"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_role_assignment" "eso_key_vault_secrets_user" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.eso.principal_id
}

resource "azurerm_federated_identity_credential" "eso" {
  name = "eso-workload-identity"

  user_assigned_identity_id = azurerm_user_assigned_identity.eso.id

  issuer   = module.aks.oidc_issuer_url
  subject = "system:serviceaccount:external-secrets:eso-keyvault"
  audience = ["api://AzureADTokenExchange"]
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}

resource "azurerm_user_assigned_identity" "github_actions" {
  name                = "github-actions-identity"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    Environment = "dev"
    Project     = "azure-lab"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_role_assignment" "github_actions_acr_push" {
  scope                = module.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}