# Create a resource group
resource "azurerm_resource_group" "k8s_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "k8s_vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.k8s_rg.name
  location            = azurerm_resource_group.k8s_rg.location
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet
resource "azurerm_subnet" "k8s_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.k8s_rg.name
  virtual_network_name = azurerm_virtual_network.k8s_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [azurerm_virtual_network.k8s_vnet]
}

# Create a Network Security Group
resource "azurerm_network_security_group" "k8s_nsg" {
  name                = "k8s-nsg"
  resource_group_name = azurerm_resource_group.k8s_rg.name
  location            = azurerm_resource_group.k8s_rg.location
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
  resource_group_name         = azurerm_resource_group.k8s_rg.name
  network_security_group_name = azurerm_network_security_group.k8s_nsg.name
}

resource "azurerm_network_interface_security_group_association" "k8s_nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.k8s_nic.id
  network_security_group_id = azurerm_network_security_group.k8s_nsg.id
}

resource "azurerm_public_ip" "k8s_pip" {
  name                = "k8s-pip"
  location            = azurerm_resource_group.k8s_rg.location
  resource_group_name = azurerm_resource_group.k8s_rg.name
  allocation_method   = "Static"
}

# Create a Virtual Machine (one as an example)
resource "azurerm_network_interface" "k8s_nic" {
  name                = "k8s-nic"
  location            = azurerm_resource_group.k8s_rg.location
  resource_group_name = azurerm_resource_group.k8s_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8s_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "k8s_vm" {
  name                = "k8s-node-1"
  resource_group_name = azurerm_resource_group.k8s_rg.name
  location            = azurerm_resource_group.k8s_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.k8s_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
    # public_key = file("/Users/mducommun/Library/CloudStorage/OneDrive-VMware,Inc/workspace/azure-kubernetes/.secrets/github_action_key.pub")
  }
}
