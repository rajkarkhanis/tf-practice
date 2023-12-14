resource "azurerm_linux_virtual_machine_scale_set" "my-scale-set" {
  name = "my-scale-set"
  location = var.location
  resource_group_name = azurerm_resource_group.my-rg.name

  admin_username = "adminuser"
  sku = "Standard_B1s"
  upgrade_mode = "Rolling"
  health_probe_id = azurerm_lb_probe.my-lb-probe.id

  custom_data = base64encode("#!/bin/bash\n\napt-get update && apt-get install -y nginx && systemctl enable nginx && systemctl start nginx")

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = false
    disable_automatic_rollback = false
  }

  rolling_upgrade_policy {
    max_batch_instance_percent = 20
    max_unhealthy_instance_percent = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches = "PT0S"
  }

  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }


  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name = "my-nic"
    primary = true
    network_security_group_id = azurerm_network_security_group.my-nsg.id

    ip_configuration {
      name = "my-public-ip"
      primary = true
      subnet_id = azurerm_subnet.my-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.my-lb-back-addr-pool.id]
      load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.my-lb-nat-pool.id]
    }
  }

}
