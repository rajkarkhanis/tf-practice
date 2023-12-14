resource "azurerm_monitor_autoscale_setting" "my-auto-scale" {
  name = "my-auto-scale"
  resource_group_name = azurerm_resource_group.my-rg.name
  location = var.location
  target_resource_id = azurerm_linux_virtual_machine_scale_set.my-scale-set.id

  profile {
    name = "my-scale-profile"

    capacity {
      default = 2
      minimum = 2
      maximum = 4
    }

    rule {
      metric_trigger {
        metric_name = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.my-scale-set.id
        time_grain = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 40
      }

      scale_action {
        direction = "Increase"
        type = "ChangeCount"
        value = "1"
        cooldown = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.my-scale-set.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
