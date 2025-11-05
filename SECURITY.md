# Security Configuration Guide

This document provides security best practices and configuration guidelines for the Azure Cloud Adoption Framework (CAF) Terraform module.

## Overview

This module has been hardened with secure defaults to follow security best practices. However, proper configuration is still critical for maintaining a secure Azure environment.

## ⚠️ BREAKING CHANGES - Security Hardening

As of this version, the following security defaults have been changed:

### Database Services
- **MSSQL Server**: `public_network_access_enabled` now defaults to `false` (was `true`)
- **PostgreSQL Server**: `public_network_access_enabled` now defaults to `false` (was `true`)
- **MySQL Server**: `public_network_access_enabled` now defaults to `false` (was `true`)
- **All Database Services**: `minimum_tls_version` now defaults to `"1.2"` (was `null` or `"TLSEnforcementDisabled"`)

### Key Vault
- **purge_protection_enabled**: Now defaults to `true` (was `false`)
- **public_network_access_enabled**: Now defaults to `false` (was `null`)
- **soft_delete_retention_days**: Now defaults to `90` days (was `7`)

### Other Services
- **Cognitive Services**: `public_network_access_enabled` now defaults to `false` (was `true`)
- **Machine Learning Workspace**: `public_network_access_enabled` now defaults to `false` (was `true`)
- **Container Registry**: Network ACL `default_action` now defaults to `"Deny"` (was `"Allow"`)

## 🔒 Security Best Practices

### 1. Network Security

#### Private Network Access
All services now default to private network access. To enable public access, you must explicitly set:
```hcl
public_network_access_enabled = true  # Only if absolutely required
```

#### Network ACLs
Always use `default_action = "Deny"` and explicit allow rules:
```hcl
network_acls = {
  default_action = "Deny"
  ip_rules       = ["1.2.3.4/32"]  # Your specific IP ranges

  virtual_network_subnet_ids = [
    # Reference your approved subnets
  ]
}
```

#### Private Endpoints
Use private endpoints for production workloads:
```hcl
private_endpoints = {
  sql = {
    name               = "pe-sql"
    subnet_id          = var.subnet_id
    subresource_names  = ["sqlServer"]
  }
}
```

### 2. Key Vault Security

#### Secure Configuration
```hcl
keyvaults = {
  production = {
    name                          = "kv-prod"
    resource_group_key           = "rg_security"
    sku_name                     = "standard"
    purge_protection_enabled     = true   # Prevents accidental deletion
    public_network_access_enabled = false  # Force private access
    soft_delete_retention_days   = 90     # Maximum recovery window

    network = {
      bypass         = "AzureServices"
      default_action = "Deny"

      # Add specific IP ranges or subnets as needed
      ip_rules = []
      subnets = {
        management = {
          vnet_key   = "hub"
          subnet_key = "management"
        }
      }
    }
  }
}
```

### 3. Database Security

#### MSSQL Server
```hcl
mssql_servers = {
  production = {
    name                          = "sql-prod"
    resource_group_key           = "rg_data"
    administrator_login          = "sqladmin"
    # DO NOT set administrator_login_password - let it auto-generate

    public_network_access_enabled = false  # Force private access
    minimum_tls_version           = "1.2"   # Enforce TLS 1.2

    # Use Azure AD authentication when possible
    azuread_administrator = {
      azuread_group_key = "sql_admins"
      azuread_authentication_only = true
    }

    # Enable auditing
    extended_auditing_policy = {
      storage_account_key = "audit_storage"
      retention_in_days  = 90
    }
  }
}
```

#### PostgreSQL/MySQL Servers
```hcl
postgresql_servers = {
  production = {
    name                          = "psql-prod"
    resource_group_key           = "rg_data"
    administrator_login          = "psqladmin"
    # Password will be auto-generated and stored in Key Vault

    public_network_access_enabled     = false
    ssl_enforcement_enabled           = true
    ssl_minimal_tls_version_enforced = "TLS1_2"

    # Enable infrastructure encryption
    infrastructure_encryption_enabled = true
  }
}
```

### 4. Identity and Access Management

#### Use Managed Identities
Always prefer managed identities over service principals:
```hcl
identity = {
  type = "SystemAssigned"
}

# Or for user-assigned
identity = {
  type = "UserAssigned"
  identity_ids = [var.managed_identity_id]
}
```

#### RBAC Configuration
```hcl
role_assignments = {
  sql_admin = {
    scope_key           = "sql_server"
    role_definition_key = "sql_db_contributor"
    principal_key       = "managed_identity"
  }
}
```

### 5. Storage Security

#### Storage Account Hardening
```hcl
storage_accounts = {
  secure_storage = {
    name                     = "stsecure"
    resource_group_key      = "rg_storage"
    account_tier            = "Standard"
    account_replication_type = "GRS"

    # Security settings
    min_tls_version                = "TLS1_2"
    enable_https_traffic_only      = true
    allow_nested_items_to_be_public = false
    shared_access_key_enabled      = false

    network_rules = {
      default_action = "Deny"
      bypass         = ["AzureServices"]

      ip_rules = []
      virtual_network_subnet_ids = []
    }
  }
}
```

### 6. Monitoring and Compliance

#### Enable Diagnostic Settings
```hcl
diagnostic_profiles = {
  security_logs = {
    name = "security_monitoring"
    definition_key = "all_logs_and_metrics"
    destinations = {
      log_analytics = {
        destination_key = "security_workspace"
      }
      storage = {
        destination_key = "audit_storage"
      }
    }
  }
}
```

## 🚫 What NOT to Do - Security Anti-patterns

### ❌ Hardcoded Secrets
```hcl
# NEVER DO THIS
administrator_login_password = "hardcoded_password"  # ❌
connection_string           = "Server=..."          # ❌
api_key                    = "abc123..."            # ❌
```

### ❌ Public Network Access
```hcl
# Avoid unless absolutely necessary
public_network_access_enabled = true  # ❌
default_action = "Allow"              # ❌
```

### ❌ Weak TLS Configuration
```hcl
# Don't use weak TLS
minimum_tls_version = "1.0"                    # ❌
ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"  # ❌
```

## 📋 Security Checklist

Before deploying to production, verify:

- [ ] All database services have `public_network_access_enabled = false`
- [ ] Key Vault has `purge_protection_enabled = true`
- [ ] All services enforce minimum TLS 1.2
- [ ] Network ACLs default to "Deny"
- [ ] No hardcoded passwords or secrets in configuration
- [ ] Managed identities used instead of service principals where possible
- [ ] Diagnostic logging enabled for all critical resources
- [ ] Private endpoints configured for all data services
- [ ] RBAC permissions follow principle of least privilege
- [ ] Storage accounts have public blob access disabled

## 🔧 Migration from Previous Versions

If upgrading from previous versions, you may need to:

1. **Review Public Access Settings**: Services that previously defaulted to public access now default to private
2. **Update Network Configurations**: Add explicit network rules if public access is required
3. **Check TLS Settings**: Ensure applications support TLS 1.2
4. **Review Key Vault Access**: Update applications if Key Vault public access was disabled

## 📞 Security Issues

If you discover security vulnerabilities in this module:
1. Do NOT open a public GitHub issue
2. Report privately to the maintainers
3. Follow responsible disclosure practices

## 🔗 Additional Resources

- [Azure Security Best Practices](https://docs.microsoft.com/azure/security/)
- [Azure Cloud Adoption Framework Security](https://docs.microsoft.com/azure/cloud-adoption-framework/secure/)
- [Azure Well-Architected Security Pillar](https://docs.microsoft.com/azure/architecture/framework/security/)
- [Microsoft Security Development Lifecycle](https://www.microsoft.com/securityengineering/sdl/)

---

**Remember**: Security is a shared responsibility. While this module provides secure defaults, you must still configure and manage your Azure environment according to your organization's security requirements and compliance needs.