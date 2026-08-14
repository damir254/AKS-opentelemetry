terraform {

  backend "azurerm" {

    resource_group_name = "demo"

    storage_account_name = "damirstorage"

    container_name = "demotfstate"

    key = "azure-lab/terraform.tfstate"

  }

}
