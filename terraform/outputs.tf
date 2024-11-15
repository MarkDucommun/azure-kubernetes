output "resource_group_name" {
  value = azurerm_resource_group.k8s_rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.k8s_vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.k8s_subnet.name
}

output "vm_ip_addresses" {
  value = [azurerm_linux_virtual_machine.k8s_vm.public_ip_address]
}

output "pip_ip_address" {
  value = [azurerm_public_ip.k8s_pip.ip_address]
}
