resource "azurerm_resource_group" "artizens" {
  name     = "artizens"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "artizens-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.artizens.location
  resource_group_name = azurerm_resource_group.artizens.name
}

resource "azurerm_subnet" "main" {
  name                 = "artizens-subnet"
  resource_group_name  = azurerm_resource_group.artizens.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "vm" {
  name                = "artizens-vm-nsg"
  location            = azurerm_resource_group.artizens.location
  resource_group_name = azurerm_resource_group.artizens.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_allowed_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "vm" {
  name                = "artizens-vm-public-ip"
  location            = azurerm_resource_group.artizens.location
  resource_group_name = azurerm_resource_group.artizens.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm" {
  name                = "artizens-vm-nic"
  location            = azurerm_resource_group.artizens.location
  resource_group_name = azurerm_resource_group.artizens.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

resource "azurerm_network_interface_security_group_association" "vm" {
  network_interface_id      = azurerm_network_interface.vm.id
  network_security_group_id = azurerm_network_security_group.vm.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "artizens-vm"
  resource_group_name = azurerm_resource_group.artizens.name
  location            = azurerm_resource_group.artizens.location
  size                = "Standard_B1s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
