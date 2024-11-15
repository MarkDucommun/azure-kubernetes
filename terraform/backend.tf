terraform {
  backend "azurerm" {
    resource_group_name   = "my-terraform-rg"          # Your Terraform backend resource group
    storage_account_name  = "markducommuntfstate"      # Storage account name
    container_name        = "tfstate"                  # Container for state files
    key                   = "k8s-cluster.terraform.tfstate"  # Unique key for this state file
    use_oidc              = true
    client_id = var.client_id
    tenant_id = var.tenant_id
    subscription_id = var.subscription_id
  }
}
