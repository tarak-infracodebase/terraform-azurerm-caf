# Azure Function Apps
# Serverless compute service for running functions triggered by events
# IMPORTANT: Function apps require an App Service Plan or storage account for runtime state
module "function_apps" {
  source     = "./modules/webapps/function_app"
  depends_on = [module.networking] # Network resources must exist first for VNet integration
  for_each   = local.webapp.function_apps

  # Basic configuration
  name                       = each.value.name
  client_config              = local.client_config

  # Application configuration and settings
  # dynamic_app_settings: Runtime settings resolved from combined objects (storage, keyvault, etc.)
  # app_settings: Static application settings defined in configuration
  dynamic_app_settings       = try(each.value.dynamic_app_settings, {})
  app_settings               = try(each.value.app_settings, null)
  combined_objects           = local.dynamic_app_settings_combined_objects

  # App Service Plan resolution with proper validation
  # Priority: explicit app_service_plan_id > reference via app_service_plan_key
  # VALIDATION: Ensures at least one method is provided to prevent deployment failures
  app_service_plan_id        = can(each.value.app_service_plan_id) ?
    each.value.app_service_plan_id :
    can(each.value.app_service_plan_key) ?
      local.combined_objects_app_service_plans[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.app_service_plan_key].id :
      null # This should trigger validation error below

  # Runtime and platform configuration
  settings                   = each.value.settings

  # Application Insights integration for monitoring and telemetry
  # Links to Application Insights if application_insight_key is provided
  application_insight        = try(each.value.application_insight_key, null) == null ? null : module.azurerm_application_insights[each.value.application_insight_key]

  # Monitoring and diagnostics configuration
  diagnostic_profiles        = try(each.value.diagnostic_profiles, null)
  diagnostics                = local.combined_diagnostics

  # Identity and access management
  # Supports system-assigned and user-assigned managed identities
  identity                   = try(each.value.identity, null)

  # Database and external service connections
  connection_strings         = try(each.value.connection_strings, {})

  # Storage account configuration for Function App runtime
  # Function apps require a storage account for internal state management
  # These values are resolved from data sources when storage_account_key is provided
  storage_account_name       = try(data.azurerm_storage_account.function_apps[each.key].name, null)
  storage_account_access_key = try(data.azurerm_storage_account.function_apps[each.key].primary_access_key, null)
  tags                       = try(each.value.tags, null)
  # subnet_id = try(
  #                 each.value.subnet_id,
  #                 local.combined_objects_networking[try(each.value.settings.lz_key, local.client_config.landingzone_key)][each.value.settings.vnet_key].subnets[each.value.settings.subnet_key].id,
  #                 null
  #                 )
  global_settings   = local.global_settings
  private_dns       = local.combined_objects_private_dns
  private_endpoints = try(each.value.private_endpoints, {})
  vnets             = local.combined_objects_networking
  virtual_subnets   = local.combined_objects_virtual_subnets
  remote_objects = {
    subnets = try(local.combined_objects_networking[try(each.value.settings.lz_key, local.client_config.landingzone_key)][each.value.settings.vnet_key].subnets, null)
  }

  base_tags           = local.global_settings.inherit_tags
  resource_group      = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)]
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : null
  location            = try(local.global_settings.regions[each.value.region], null)
}

output "function_apps" {
  value = module.function_apps
}

data "azurerm_storage_account" "function_apps" {
  for_each = {
    for key, value in local.webapp.function_apps : key => value
    if try(value.storage_account_key, null) != null
  }

  name                = local.combined_objects_storage_accounts[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.storage_account_key].name
  resource_group_name = local.combined_objects_storage_accounts[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.storage_account_key].resource_group_name
}

# VALIDATION: Ensure Function Apps have required configuration
check "function_app_required_configs" {
  assert {
    condition = alltrue([
      for key, app in local.webapp.function_apps :
      can(app.app_service_plan_id) || can(app.app_service_plan_key)
    ])
    error_message = "Each Function App must specify either 'app_service_plan_id' or 'app_service_plan_key'."
  }
}

check "function_app_storage_requirements" {
  assert {
    condition = alltrue([
      for key, app in local.webapp.function_apps :
      can(app.storage_account_key) || can(app.storage_account_name)
    ])
    error_message = "Each Function App must specify either 'storage_account_key' or 'storage_account_name' for runtime storage."
  }
}

# VALIDATION: Security check for Function Apps
check "function_app_security_defaults" {
  assert {
    condition = alltrue([
      for key, app in local.webapp.function_apps :
      try(app.settings.https_only, true) == true
    ])
    error_message = "Function Apps should enforce HTTPS-only traffic for security."
  }
}
