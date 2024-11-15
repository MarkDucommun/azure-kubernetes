terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
  use_oidc = true
  tenant_id = var.tenant_id
  client_id = var.client_id
  subscription_id = var.subscription_id
}
