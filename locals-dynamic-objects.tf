# Dynamic Application Settings and Combined Objects
# These objects are used for cross-service references and application configuration

locals {
  # Dynamic app settings used by applications and services
  # Provides runtime configuration combining local and remote objects
  dynamic_app_settings_combined_objects = {
    app_config                  = local.combined_objects_app_config
    azure_container_registries  = local.combined_objects_azure_container_registries
    client_config               = tomap({ (local.client_config.landingzone_key) = { config = local.client_config } })
    cosmos_dbs                  = local.combined_objects_cosmos_dbs
    keyvaults                   = local.combined_objects_keyvaults
    machine_learning_workspaces = local.combined_objects_machine_learning
    managed_identities          = local.combined_objects_managed_identities
    mssql_databases             = local.combined_objects_mssql_databases
    mssql_servers               = local.combined_objects_mssql_servers
    maintenance_configuration   = local.combined_objects_maintenance_configuration
    signalr_services            = local.combined_objects_signalr_services
    storage_accounts            = local.combined_objects_storage_accounts
    networking                  = local.combined_objects_networking
  }

  # Dynamic app config objects for Azure App Configuration service
  # Provides centralized configuration management across services
  dynamic_app_config_combined_objects = {
    azure_container_registries   = local.combined_objects_azure_container_registries
    azurerm_application_insights = tomap({ (local.client_config.landingzone_key) = module.azurerm_application_insights })
    client_config                = tomap({ (local.client_config.landingzone_key) = { config = local.client_config } })
    keyvaults                    = local.combined_objects_keyvaults
    logic_app_workflow           = local.combined_objects_logic_app_workflow
    machine_learning_workspaces  = local.combined_objects_machine_learning
    managed_identities           = local.combined_objects_managed_identities
    resource_groups              = local.combined_objects_resource_groups
    storage_accounts             = local.combined_objects_storage_accounts
  }
}

# SECURITY WARNING: These combined objects contain references to sensitive resources
# Ensure proper access controls are in place when consuming these values
# Consider implementing least-privilege access patterns in consuming modules