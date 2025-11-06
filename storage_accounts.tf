
# SECURITY ENHANCED: Storage accounts with CMK enforcement and private endpoints
module "storage_accounts" {
  source   = "./modules/storage_account"
  for_each = var.storage_accounts

  client_config             = local.client_config
  diagnostic_profiles       = try(each.value.diagnostic_profiles, {})
  diagnostic_profiles_blob  = try(each.value.diagnostic_profiles_blob, {})
  diagnostic_profiles_queue = try(each.value.diagnostic_profiles_queue, {})
  diagnostic_profiles_table = try(each.value.diagnostic_profiles_table, {})
  diagnostic_profiles_file  = try(each.value.diagnostic_profiles_file, {})
  diagnostics               = local.combined_diagnostics
  global_settings           = local.global_settings
  managed_identities        = local.combined_objects_managed_identities
  private_dns               = local.combined_objects_private_dns

  # SECURITY ENHANCEMENT: Ensure private endpoints are configured unless explicitly disabled
  private_endpoints         = local.current_environment_security.require_private_endpoints ?
                             merge(try(each.value.private_endpoints, {}), {
                               enable_private_endpoint = true
                             }) : try(each.value.private_endpoints, {})

  recovery_vaults           = local.combined_objects_recovery_vaults

  # SECURITY ENHANCEMENT: Merge security defaults with user configuration
  storage_account = merge(each.value, {
    # Apply security defaults that can be overridden by user configuration
    min_tls_version                   = try(each.value.min_tls_version, local.current_environment_security.storage_min_tls_version)
    enable_https_traffic_only         = try(each.value.enable_https_traffic_only, local.current_environment_security.storage_require_secure_transfer)
    allow_nested_items_to_be_public   = try(each.value.allow_nested_items_to_be_public, local.current_environment_security.storage_allow_nested_items_to_be_public)
    cross_tenant_replication_enabled  = try(each.value.cross_tenant_replication_enabled, local.current_environment_security.storage_cross_tenant_replication_enabled)
    public_network_access_enabled     = try(each.value.public_network_access_enabled, !local.current_environment_security.disable_public_network_access)
  })

  var_folder_path           = var.var_folder_path
  vnets                     = local.combined_objects_networking
  virtual_subnets           = local.combined_objects_virtual_subnets

  base_tags           = local.global_settings.inherit_tags
  resource_group      = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)]
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : null
  location            = try(local.global_settings.regions[each.value.region], null)
}

output "storage_accounts" {
  value     = module.storage_accounts
  sensitive = true
}

# SECURITY ENHANCED: Customer-managed keys with production enforcement
resource "azurerm_storage_account_customer_managed_key" "cmk" {
  depends_on = [module.keyvault_access_policies]
  for_each = {
    for key, value in var.storage_accounts : key => value
    # SECURITY ENHANCEMENT: Enforce CMK for production environments or when explicitly configured
    if can(value.customer_managed_key) || (local.current_environment_security.enforce_cmk_encryption && local.global_settings.environment == "production")
  }

  storage_account_id = module.storage_accounts[each.key].id
  key_vault_id       = local.combined_objects_keyvaults[try(each.value.customer_managed_key.lz_key, local.client_config.landingzone_key)][try(each.value.customer_managed_key.keyvault_key, "default_cmk")].id
  key_name           = can(each.value.customer_managed_key.key_name) ? each.value.customer_managed_key.key_name : local.combined_objects_keyvault_keys[try(each.value.customer_managed_key.lz_key, local.client_config.landingzone_key)][try(each.value.customer_managed_key.keyvault_key_key, "default_cmk_key")].name
  key_version        = try(each.value.customer_managed_key.key_version, null)
}

# SECURITY CHECK: Validate that production storage accounts use CMK
check "production_storage_cmk" {
  assert {
    condition = local.global_settings.environment == "production" ?
      alltrue([for k, v in var.storage_accounts : can(v.customer_managed_key) || local.current_environment_security.enforce_cmk_encryption]) : true
    error_message = "Production storage accounts must use customer-managed keys for encryption."
  }
}

module "encryption_scopes" {
  source = "./modules/storage_account/encryption_scope"
  for_each = {
    for key, value in var.storage_accounts : key => value
    if can(value.encryption_scopes)
  }

  client_config      = local.client_config
  settings           = each.value
  storage_account_id = module.storage_accounts[each.key].id
  keyvault_keys      = local.combined_objects_keyvault_keys
}
