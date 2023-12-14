resource "azurerm_linux_virtual_machine" "first-vm" {
    name = "first-vm"
    location = var.location
    resource_group_name = azurerm_resource_group.first-rg.name
    network_interface_ids = [azurerm_network_interface.first-nic.id]
    size = "Standard_B1s"

    admin_username = "adminuser"
    admin_ssh_key {
        username = "adminuser"
        public_key = file("~/.ssh/id_rsa.pub")
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }
}

resource "azurerm_network_interface" "first-nic" {
    name = "first-nic"
    location = var.location
    resource_group_name = azurerm_resource_group.first-rg.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.first-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.first-public-ip.id
    }
}

resource "azurerm_network_interface_security_group_association" "first-nsg-nic-association" {
    network_interface_id = azurerm_network_interface.first-nic.id
    network_security_group_id = azurerm_network_security_group.first-nsg.id
}

resource "azurerm_public_ip" "first-public-ip" {
    name = "first-public-ip"
    location = var.location
    resource_group_name = azurerm_resource_group.first-rg.name
    allocation_method = "Dynamic"
}
