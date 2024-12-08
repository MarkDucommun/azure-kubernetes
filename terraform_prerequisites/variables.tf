variable "resource_group_name" {
  description = "Name of the resource group for the Kubernetes cluster"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Central US"
}
