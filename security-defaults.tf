# Security Defaults and Hardening
# Implements enterprise security best practices across all services

locals {
  # Enhanced security defaults applied across all resources
  security_defaults = {
    # Encryption settings
    enforce_cmk_encryption         = true
    minimum_tls_version           = "1.2"
    require_ssl                   = true

    # Network security
    require_private_endpoints      = true
    disable_public_network_access  = true
    enable_firewall_rules         = true

    # Monitoring and compliance
    enable_diagnostic_logging      = true
    enable_advanced_threat_protection = true
    enable_vulnerability_assessment = true

    # Access control
    require_rbac_authorization     = true
    enforce_mfa                   = true

    # Application Gateway security
    enforce_waf_policies          = true
    waf_mode                      = "Prevention"
    waf_rule_set_version         = "3.2"

    # Key Vault security
    keyvault_soft_delete_retention_days = 90
    keyvault_purge_protection_enabled   = true
    keyvault_enable_rbac_authorization  = true

    # Storage Account security
    storage_min_tls_version             = "TLS1_2"
    storage_require_secure_transfer     = true
    storage_allow_nested_items_to_be_public = false
    storage_cross_tenant_replication_enabled = false
  }

  # Validated environment-specific security configurations
  environment_security_config = {
    production = merge(local.security_defaults, {
      # Production-specific hardening
      keyvault_purge_protection_enabled = true
      storage_cross_tenant_replication_enabled = false
      require_private_endpoints = true
      waf_mode = "Prevention"
    })

    staging = merge(local.security_defaults, {
      # Staging allows some flexibility for testing
      waf_mode = "Detection"
      keyvault_soft_delete_retention_days = 30
    })

    development = merge(local.security_defaults, {
      # Development has relaxed restrictions but maintains core security
      disable_public_network_access = false
      waf_mode = "Detection"
      keyvault_soft_delete_retention_days = 7
    })
  }

  # Get current environment security config
  current_environment_security = try(
    local.environment_security_config[local.global_settings.environment],
    local.security_defaults
  )
}

# Validation rules to prevent insecure configurations
locals {
  # Validate that production environments use secure configurations
  validate_production_security = (
    local.global_settings.environment == "production" ?
    local.current_environment_security.require_private_endpoints == true &&
    local.current_environment_security.keyvault_purge_protection_enabled == true &&
    local.current_environment_security.waf_mode == "Prevention" : true
  )
}

# Ensure production environments cannot disable critical security features
check "production_security_validation" {
  assert {
    condition = local.validate_production_security
    error_message = "Production environments must enforce private endpoints, Key Vault purge protection, and WAF prevention mode."
  }
}