output "resource_group_name" {
  value = data.azurerm_resource_group.k8s_rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.k8s_vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.k8s_subnet.name
}

output "vm_public_ip" {
  value       = azurerm_public_ip.k8s_pip.ip_address
  description = "Public IP address of the Kubernetes node"
}

output "vm_fqdn" {
  value = azurerm_public_ip.k8s_pip.fqdn
}

output "oidc_client_id" {
  value       = var.oidc_client_id
  description = "Client ID of the Azure AD OIDC application"
}
