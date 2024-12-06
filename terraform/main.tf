# Create a resource group
# resource "azurerm_resource_group" "k8s_rg" {
#   name     = var.resource_group_name
#   location = var.location
# }

data "azurerm_resource_group" "k8s_rg" {
  name = var.resource_group_name
}

# Create a virtual network
resource "azurerm_virtual_network" "k8s_vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.k8s_rg.name
  location            = data.azurerm_resource_group.k8s_rg.location
  address_space = ["10.0.0.0/16"]
}

# Create a subnet
resource "azurerm_subnet" "k8s_subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.k8s_rg.name
  virtual_network_name = azurerm_virtual_network.k8s_vnet.name
  address_prefixes = ["10.0.1.0/24"]

  depends_on = [azurerm_virtual_network.k8s_vnet]
}

# Create a Network Security Group
resource "azurerm_network_security_group" "k8s_nsg" {
  name                = "k8s-nsg"
  resource_group_name = data.azurerm_resource_group.k8s_rg.name
  location            = data.azurerm_resource_group.k8s_rg.location
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow-ssh"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.k8s_rg.name
  network_security_group_name = azurerm_network_security_group.k8s_nsg.name
}

resource "azurerm_network_security_rule" "allow_k8s_api" {
  name                        = "allow-k8s-api"
  priority = 1001  # Ensure the priority does not conflict with existing rules
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.k8s_rg.name
  network_security_group_name = azurerm_network_security_group.k8s_nsg.name
}

resource "azurerm_network_interface_security_group_association" "k8s_nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.k8s_nic.id
  network_security_group_id = azurerm_network_security_group.k8s_nsg.id
}

resource "azurerm_public_ip" "k8s_pip" {
  name                = "k8s-pip"
  location            = data.azurerm_resource_group.k8s_rg.location
  resource_group_name = data.azurerm_resource_group.k8s_rg.name
  allocation_method   = "Static"
}

# Create a Virtual Machine (one as an example)
resource "azurerm_network_interface" "k8s_nic" {
  name                = "k8s-nic"
  location            = data.azurerm_resource_group.k8s_rg.location
  resource_group_name = data.azurerm_resource_group.k8s_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8s_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s_pip.id
  }
}

# resource "azuread_application" "k8s_oidc_app" {
#   display_name = "k8s-oidc-app"
# }

# resource "azuread_service_principal" "k8s_oidc_sp" {
#   client_id = azuread_application.k8s_oidc_app.client_id
# }
#
# resource "azurerm_role_assignment" "k8s_oidc_role_assignment" {
#   principal_id         = azuread_service_principal.k8s_oidc_sp.object_id
#   role_definition_name = "Contributor"
#   scope                = "/subscriptions/${var.azure_subscription_id}"
# }
#
# resource "azuread_application_federated_identity_credential" "k8s_oidc_fic" {
#   application_id = azuread_application.k8s_oidc_app.id
#   display_name   = "k8s-oidc-credential"
#   issuer         = "https://${azurerm_public_ip.k8s_pip.ip_address}/"
#   subject        = "system:serviceaccount:default:oidc-auth-sa"
#   audiences = [azuread_application.k8s_oidc_app.client_id]
# }

resource "azurerm_linux_virtual_machine" "k8s_vm" {
  name                = "k8s-node-1"
  resource_group_name = data.azurerm_resource_group.k8s_rg.name
  location            = data.azurerm_resource_group.k8s_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.k8s_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # source_image_id = var.custom_image_id
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
    # public_key = file("/Users/mducommun/Library/CloudStorage/OneDrive-VMware,Inc/workspace/azure-kubernetes/.secrets/github_action_key.pub")
  }
}
