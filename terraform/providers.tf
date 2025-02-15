terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
  use_oidc = true
}
