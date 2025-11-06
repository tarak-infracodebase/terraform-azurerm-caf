# Core Configuration local values
# Contains fundamental configuration that's used across all resources

# Random prefix generation for resource naming when no custom prefix provided
resource "random_string" "prefix" {
  count   = try(var.global_settings.prefix, null) == null ? 1 : 0
  length  = 4
  special = false
  upper   = false
  numeric = false
}

locals {
  # Client configuration - provides authentication and tenant context
  # Uses data sources as fallback when var.client_config is empty
  client_config = var.client_config == {} ? {
    client_id               = data.azuread_client_config.current.client_id
    landingzone_key         = var.current_landingzone_key
    logged_aad_app_objectId = local.object_id
    logged_user_objectId    = local.object_id
    object_id               = local.object_id
    subscription_id         = data.azurerm_client_config.current.subscription_id
    tenant_id               = data.azurerm_client_config.current.tenant_id
  } : tomap(var.client_config)

  # Object ID resolution from multiple possible sources
  # Prioritizes logged_user_objectId, then logged_aad_app_objectId, then data source lookups
  object_id = coalesce(
    var.logged_user_objectId,
    var.logged_aad_app_objectId,
    try(data.azuread_client_config.current.object_id, null),
    try(data.azuread_service_principal.logged_in_app[0].object_id, null)
  )

  # Global settings merged with defaults and variable overrides
  # Provides consistent configuration across all resources
  global_settings = merge({
    default_region     = try(var.global_settings.default_region, "region1")
    environment        = try(var.global_settings.environment, var.environment)
    inherit_tags       = try(var.global_settings.inherit_tags, false)
    passthrough        = try(var.global_settings.passthrough, false)
    prefix             = try(var.global_settings.prefix, null)
    prefix_with_hyphen = try(var.global_settings.prefix_with_hyphen, format("%s-", try(var.global_settings.prefix, try(var.global_settings.prefixes[0], random_string.prefix[0].result))))
    prefixes           = try(var.global_settings.prefix, null) == "" ? null : try([var.global_settings.prefix], try(var.global_settings.prefixes, [random_string.prefix[0].result]))
    random_length      = try(var.global_settings.random_length, 0)
    regions            = try(var.global_settings.regions, null)
    tags               = try(var.global_settings.tags, null)
    use_slug           = try(var.global_settings.use_slug, true)
  }, var.global_settings)

  # Feature enablement flags
  # Allows conditional resource creation based on requirements
  enable = {
    bastion_hosts    = try(var.enable.bastion_hosts, true)
    virtual_machines = try(var.enable.virtual_machines, true)
  }
}