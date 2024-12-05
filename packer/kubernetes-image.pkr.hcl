source "variables" {
  file = "variables.pkr.hcl"
}


source "azure-arm" "kubernetes-image" {
  # Azure subscription and resource group
  subscription_id = var.azure_subscription_id
  tenant_id       = "{{ env `AZURE_TENANT_ID` }}"
  resource_group_name  = "packer-rg"
  storage_account      = "packerstorageaccount"
  managed_image_name   = "kubernetes-image"
  managed_image_resource_group_name = "packer-rg"
  location             = "East US"

  # Base OS
  os_type       = "Linux"
  image_publisher = "Canonical"
  image_offer     = "ubuntu-24_04-lts"
  image_sku       = "server"
  image_version   = "latest"
  vm_size         = "Standard_B1s"

  # OIDC Authentication
  use_oidc = true
  client_id = "{{ env `AZURE_CLIENT_ID` }}"  # OIDC-enabled Azure Application's Client ID
}

# Define the build step
build {
  name    = "kubernetes-image-build"
  sources = ["source.azure-arm.kubernetes-image"]

  # Use Ansible for provisioning
  provisioner "ansible" {
    playbook_file   = "../ansible/provision_k8s.yml"
    user            = "azureuser"
    extra_arguments = ["-i", "localhost,", "--private-key=/path/to/your/private/key"]

    # Additional variables can be passed if needed
    extra_vars = {
      azure_subscription_id = "{{ env `AZURE_SUBSCRIPTION_ID` }}"
    }
  }
}
