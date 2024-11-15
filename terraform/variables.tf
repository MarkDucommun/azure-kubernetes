variable "resource_group_name" {
  description = "Name of the resource group for the Kubernetes cluster"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Central US"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "k8s-vnet"
}

variable "subnet_name" {
  description = "Name of the subnet for the Kubernetes nodes"
  type        = string
  default     = "k8s-subnet"
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

# variable "admin_ssh_public_key" {
#   description = "Public SSH key for accessing the VMs"
#   type        = string
# }
#
# variable "tenant_id" {
#   description = "Azure Tenant ID"
#   type        = string
# }
#
# variable "client_id" {
#   description = "Azure Client ID"
#   type        = string
# }
#
# variable "subscription_id" {
#   description = "Azure Subscription ID"
#   type        = string
# }
