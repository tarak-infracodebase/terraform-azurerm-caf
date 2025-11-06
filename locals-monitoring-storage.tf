# Monitoring, Storage, and Shared Services local values
# Includes monitoring, automation, storage, backup, and maintenance services

locals {
  # Shared services - monitoring, automation, and operational tools
  shared_services = {
    automations                               = try(var.shared_services.automations, {})
    automation_schedules                      = try(var.shared_services.automation_schedules, {})
    automation_runbooks                       = try(var.shared_services.automation_runbooks, {})
    automation_log_analytics_links            = try(var.shared_services.automation_log_analytics_links, {})
    automation_software_update_configurations = try(var.shared_services.automation_software_update_configurations, {})
    consumption_budgets                       = try(var.shared_services.consumption_budgets, {})
    image_definitions                         = try(var.shared_services.image_definitions, {})
    log_analytics_storage_insights            = try(var.shared_services.log_analytics_storage_insights, {})
    monitor_autoscale_settings                = try(var.shared_services.monitor_autoscale_settings, {})
    monitor_action_groups                     = try(var.shared_services.monitor_action_groups, {})
    monitoring                                = try(var.shared_services.monitoring, {})
    monitor_metric_alert                      = try(var.shared_services.monitor_metric_alert, {})
    monitor_activity_log_alert                = try(var.shared_services.monitor_activity_log_alert, {})
    packer_service_principal                  = try(var.shared_services.packer_service_principal, {})
    packer_build                              = try(var.shared_services.packer_build, {})
    recovery_vaults                           = try(var.shared_services.recovery_vaults, {})
    shared_image_galleries                    = try(var.shared_services.shared_image_galleries, {})
  }

  # Storage services including NetApp and various storage account types
  storage = {
    netapp_accounts             = try(var.storage.netapp_accounts, {})
    storage_account_blobs       = try(var.storage.storage_account_blobs, {})
    storage_account_file_shares = try(var.storage.storage_account_file_shares, {})
    storage_account_queues      = try(var.storage.storage_account_queues, {})
    storage_containers          = try(var.storage.storage_containers, {})
  }

  # Data protection and backup services
  data_protection = {
    backup_vaults          = try(var.data_protection.backup_vaults, {})
    backup_vault_policies  = try(var.data_protection.backup_vault_policies, {})
    backup_vault_instances = try(var.data_protection.backup_vault_instances, {})
  }

  # Maintenance and configuration management
  maintenance = {
    maintenance_configuration              = try(var.maintenance.maintenance_configuration, {})
    maintenance_assignment_virtual_machine = try(var.maintenance.maintenance_assignment_virtual_machine, {})
  }
}