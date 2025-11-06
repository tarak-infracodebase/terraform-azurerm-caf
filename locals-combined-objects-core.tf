# Combined Objects - Core Infrastructure
# These merge local, remote, and data source objects for cross-landing-zone support
# SECURITY NOTE: Contains sensitive resource references - implement proper access controls

locals {
  # Azure AD and Identity combined objects
  combined_objects_aadb2c_directory                               = merge(tomap({ (local.client_config.landingzone_key) = module.aadb2c_directory }), lookup(var.remote_objects, "aadb2c_directory", {}))
  combined_objects_azuread_administrative_units                   = merge(tomap({ (local.client_config.landingzone_key) = module.azuread_administrative_unit }), lookup(var.remote_objects, "administrative_units", {}))
  combined_objects_azuread_applications                           = merge(tomap({ (local.client_config.landingzone_key) = module.azuread_applications_v1 }), lookup(var.remote_objects, "azuread_applications", {}))
  combined_objects_azuread_apps                                   = merge(tomap({ (local.client_config.landingzone_key) = module.azuread_applications }), lookup(var.remote_objects, "azuread_apps", {}))
  combined_objects_azuread_groups                                 = merge(tomap({ (local.client_config.landingzone_key) = merge(module.azuread_groups, lookup(var.data_sources, "azuread_groups", {})) }), lookup(var.remote_objects, "azuread_groups", {}))
  combined_objects_azuread_service_principal_passwords            = merge(tomap({ (local.client_config.landingzone_key) = module.azuread_service_principal_passwords }), lookup(var.remote_objects, "azuread_service_principal_passwords", {}))
  combined_objects_azuread_service_principals                     = merge(tomap({ (local.client_config.landingzone_key) = module.azuread_service_principals }), lookup(var.remote_objects, "azuread_service_principals", {}), lookup(var.data_sources, "azuread_service_principals", {}))
  combined_objects_azuread_users                                  = merge(tomap({ (local.client_config.landingzone_key) = module.azuread_users }), lookup(var.remote_objects, "azuread_users", {}), lookup(var.data_sources, "azuread_users", {}))

  # Core infrastructure combined objects
  combined_objects_resource_groups                                = merge(tomap({ (local.client_config.landingzone_key) = merge(local.resource_groups, lookup(var.data_sources, "resource_groups", {})) }), lookup(var.remote_objects, "resource_groups", {}))
  combined_objects_managed_identities                             = merge(tomap({ (local.client_config.landingzone_key) = module.managed_identities }), lookup(var.remote_objects, "managed_identities", {}), lookup(var.data_sources, "managed_identities", {}))

  # Key Vault and security combined objects with enhanced security
  combined_objects_keyvault_certificate_requests                  = merge(tomap({ (local.client_config.landingzone_key) = module.keyvault_certificate_requests }), lookup(var.remote_objects, "keyvault_certificate_requests", {}))
  combined_objects_keyvault_certificates                          = merge(tomap({ (local.client_config.landingzone_key) = module.keyvault_certificates }), lookup(var.remote_objects, "keyvault_certificates", {}), lookup(var.data_sources, "keyvault_certificates", {}))
  combined_objects_keyvault_keys                                  = merge(tomap({ (local.client_config.landingzone_key) = merge(module.keyvault_keys, lookup(var.data_sources, "keyvault_keys", {})) }), lookup(var.remote_objects, "keyvault_keys", {}), lookup(var.data_sources, "keyvault_keys", {}))
  combined_objects_keyvaults                                      = merge(tomap({ (local.client_config.landingzone_key) = merge(module.keyvaults, lookup(var.data_sources, "keyvaults", {})) }), lookup(var.remote_objects, "keyvaults", {}))

  # Enhanced disk encryption with customer-managed keys by default
  combined_objects_disk_encryption_sets                           = merge(tomap({ (local.client_config.landingzone_key) = merge(module.disk_encryption_sets, module.disk_encryption_sets_external) }), lookup(var.remote_objects, "disk_encryption_sets", {}), lookup(var.remote_objects, "disk_encryption_sets_external", {}), lookup(var.data_sources, "disk_encryption_sets", {}))

  # Subscription management with billing context
  combined_objects_subscriptions = merge(
    tomap(
      {
        (local.client_config.landingzone_key) = merge(
          module.subscriptions,
          { ("logged_in_subscription") = { id = data.azurerm_subscription.primary.id } },
          lookup(var.data_sources, "subscriptions", {})
        )
      }
    ),
    lookup(var.remote_objects, "subscriptions", {})
  )
}