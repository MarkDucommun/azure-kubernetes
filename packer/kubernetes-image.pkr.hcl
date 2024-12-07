variable "arm_client_id" {
  type    = string
  default = "${env("ARM_CLIENT_ID")}"
}

variable "arm_oidc_token" {
  type    = string
  default = "${env("ARM_OIDC_TOKEN")}"
}

variable "subscription_id" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}


packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/ansible"
    }
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.2.0"
    }
  }
}

source "azure-arm" "kubernetes-image" {
  client_id                         = "${var.arm_client_id}"
  client_jwt                        = "${var.arm_oidc_token}"
  subscription_id                   = "${var.subscription_id}"
  managed_image_name                = "kubernetes-image"
  managed_image_resource_group_name = "test-k8s"
  location                          = "Central US"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "ubuntu-24_04-lts"
  image_sku       = "server"
  image_version   = "latest"
  vm_size         = "Standard_B1s"
}

build {
  name = "kubernetes-image-build"
  sources = ["source.azure-arm.kubernetes-image"]

  provisioner "ansible" {
    playbook_file = "../ansible_packer/provision_k8s.yml"
    user          = "azureuser"
    extra_arguments = [
      # "-i",
      # "localhost,",
      "--private-key=~/.ssh/github_action_key",
      "--extra-vars",
      "@/../ansible_packer/vars.yml"
    ]
  }
}
