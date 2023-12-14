resource "azurerm_virtual_network" "first-vn" {
    name = "first-vnet"
    resource_group_name = azurerm_resource_group.first-rg.name
    address_space = ["10.0.0.0/16"]
    location = var.location
}

resource "azurerm_subnet" "first-subnet" {
    name = "first-subnet"
    resource_group_name = azurerm_resource_group.first-rg.name
    virtual_network_name = azurerm_virtual_network.first-vn.name
    address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "first-nsg" {
    name = "first-nsg"
    location = var.location
    resource_group_name = azurerm_resource_group.first-rg.name

    security_rule {
        name = "Allow-SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = var.ssh-source-address
        destination_address_prefix = "*"
    }
}
