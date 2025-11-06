# Security Services local values
# Includes Key Vault, certificates, encryption, and Microsoft Sentinel components

locals {
  security = {
    # Encryption and key management
    disk_encryption_sets                = try(var.security.disk_encryption_sets, {})
    dynamic_keyvault_secrets            = try(var.security.dynamic_keyvault_secrets, {})
    keyvault_certificate_issuers        = try(var.security.keyvault_certificate_issuers, {})
    keyvault_certificate_requests       = try(var.security.keyvault_certificate_requests, {})
    keyvault_certificates               = try(var.security.keyvault_certificates, {})
    keyvault_keys                       = try(var.security.keyvault_keys, {})

    # Azure Lighthouse for multi-tenant management
    lighthouse_definitions              = try(var.security.lighthouse_definitions, {})

    # Microsoft Sentinel security orchestration, automation, and response (SOAR)
    sentinel_automation_rules           = try(var.security.sentinel_automation_rules, {})
    sentinel_watchlists                 = try(var.security.sentinel_watchlists, {})
    sentinel_watchlist_items            = try(var.security.sentinel_watchlist_items, {})

    # Sentinel Analytics Rules for threat detection
    sentinel_ar_fusions                 = try(var.security.sentinel_ar_fusions, {})
    sentinel_ar_ml_behavior_analytics   = try(var.security.sentinel_ar_ml_behavior_analytics, {})
    sentinel_ar_ms_security_incidents   = try(var.security.sentinel_ar_ms_security_incidents, {})
    sentinel_ar_scheduled               = try(var.security.sentinel_ar_scheduled, {})

    # Sentinel Data Connectors for threat intelligence and log ingestion
    sentinel_dc_aad                     = try(var.security.sentinel_dc_aad, {})
    sentinel_dc_app_security            = try(var.security.sentinel_dc_app_security, {})
    sentinel_dc_aws                     = try(var.security.sentinel_dc_aws, {})
    sentinel_dc_azure_threat_protection = try(var.security.sentinel_dc_azure_threat_protection, {})
    sentinel_dc_ms_threat_protection    = try(var.security.sentinel_dc_ms_threat_protection, {})
    sentinel_dc_office_365              = try(var.security.sentinel_dc_office_365, {})
    sentinel_dc_security_center         = try(var.security.sentinel_dc_security_center, {})
    sentinel_dc_threat_intelligence     = try(var.security.sentinel_dc_threat_intelligence, {})
  }

  # Identity and access management services
  identity = {
    active_directory_domain_service             = try(var.identity.active_directory_domain_service, {})
    active_directory_domain_service_replica_set = try(var.identity.active_directory_domain_service_replica_set, {})
  }
}