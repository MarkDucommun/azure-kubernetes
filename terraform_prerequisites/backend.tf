terraform {
  backend "azurerm" {
    resource_group_name = "my-terraform-rg"          # Your Terraform backend resource group
    storage_account_name = "markducommuntfstate"      # Storage account name
    container_name = "tfstate"                  # Container for state files
    key = "k8s-cluster-prerequisites.terraform.tfstate"  # Unique key for this state file
    use_oidc = true
  }
}
