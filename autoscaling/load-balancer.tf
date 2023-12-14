resource "azurerm_lb" "my-lb" {
  name                = "my-lb"
  sku                 = "Basic"
  location            = var.location
  resource_group_name = azurerm_resource_group.my-rg.name

  frontend_ip_configuration {
    name                 = "my-public-ip"
    public_ip_address_id = azurerm_public_ip.my-public-ip.id
  }
}

resource "azurerm_public_ip" "my-public-ip" {
  name                = "my-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.my-rg.name
  allocation_method   = "Static"
  domain_name_label   = azurerm_resource_group.my-rg.name
  sku                 = "Basic"
}

resource "azurerm_lb_backend_address_pool" "my-lb-back-addr-pool" {
  loadbalancer_id = azurerm_lb.my-lb.id
  name            = "my-lb-back-addr-pool"
}

resource "azurerm_lb_nat_pool" "my-lb-nat-pool" {
  resource_group_name            = azurerm_resource_group.my-rg.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.my-lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "my-public-ip"
}

resource "azurerm_lb_probe" "my-lb-probe" {
  loadbalancer_id = azurerm_lb.my-lb.id
  name            = "my-lb-probe"
  protocol        = "Http"
  request_path    = "/"
  port            = 80
}

resource "azurerm_lb_rule" "my-lb-rule" {
  loadbalancer_id                = azurerm_lb.my-lb.id
  name                           = "my-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "my-public-ip"
  probe_id                       = azurerm_lb_probe.my-lb-probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.my-lb-back-addr-pool.id]
}
