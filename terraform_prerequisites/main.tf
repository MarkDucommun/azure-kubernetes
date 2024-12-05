# Create a resource group
resource "azurerm_resource_group" "k8s_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "k8s_packer_storage_account" {
  name                     = var.packer_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
