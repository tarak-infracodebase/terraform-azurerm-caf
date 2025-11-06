# VM Auto-Shutdown Policy for Cost Optimization
# This module creates automatic shutdown schedules for VMs in dev/test environments
# Can save 70%+ on VM costs by shutting down VMs during off-hours

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  for_each = var.virtual_machines

  virtual_machine_id    = each.value.id
  location              = each.value.location
  enabled               = try(each.value.auto_shutdown.enabled, var.default_auto_shutdown.enabled, true)

  daily_recurrence_time = try(each.value.auto_shutdown.shutdown_time, var.default_auto_shutdown.shutdown_time, "1900")
  timezone              = try(each.value.auto_shutdown.timezone, var.default_auto_shutdown.timezone, "UTC")

  notification_settings {
    enabled         = try(each.value.auto_shutdown.notifications.enabled, var.default_auto_shutdown.notifications.enabled, false)
    time_in_minutes = try(each.value.auto_shutdown.notifications.time_in_minutes, var.default_auto_shutdown.notifications.time_in_minutes, 15)
    webhook_url     = try(each.value.auto_shutdown.notifications.webhook_url, var.default_auto_shutdown.notifications.webhook_url, "")
    email           = try(each.value.auto_shutdown.notifications.email, var.default_auto_shutdown.notifications.email, "")
  }

  tags = merge(var.base_tags, try(each.value.tags, {}), {
    cost_optimization = {
      auto_shutdown_enabled = "true"
      estimated_savings_pct = "70"
      shutdown_time         = try(each.value.auto_shutdown.shutdown_time, var.default_auto_shutdown.shutdown_time, "1900")
      environment          = try(each.value.environment, "dev")
    }
  })
}

# Output the created shutdown schedules for reference
output "vm_shutdown_schedules" {
  value = azurerm_dev_test_global_vm_shutdown_schedule.shutdown
}