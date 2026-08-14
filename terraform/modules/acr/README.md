# Azure Container Registry module

Creates a single Azure Container Registry.

## Usage

```hcl
module "acr" {
  source = "./modules/acr"

  name                = "myprojectacr"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Basic"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

The `sku` input defaults to `"Basic"`, and `tags` defaults to an empty map, so
both can be omitted when their defaults are suitable.

Available outputs are `id`, `name`, and `login_server`.
