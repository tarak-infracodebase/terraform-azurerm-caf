# Terratest Suite for Azure CAF

This directory contains automated tests for the Azure Cloud Adoption Framework (CAF) Terraform modules using [Terratest](https://terratest.gruntwork.io/).

## Overview

The test suite validates:
- **Basic Infrastructure Deployment**: Resource group creation, naming conventions, tagging
- **Security Configurations**: Storage account encryption, Key Vault settings, network security
- **Cross-Service Integration**: Verify resources work together correctly
- **Environment-Specific Configurations**: Production vs development security defaults

## Prerequisites

1. **Go 1.21+** installed
2. **Azure CLI** installed and authenticated
3. **Terraform** installed
4. **Azure subscription** with appropriate permissions

### Required Environment Variables

```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_CLIENT_ID="your-client-id"          # If using Service Principal
export ARM_CLIENT_SECRET="your-client-secret"  # If using Service Principal
export ARM_TENANT_ID="your-tenant-id"          # If using Service Principal
```

## Running Tests

### Initialize Go modules
```bash
cd test
go mod tidy
```

### Run all tests
```bash
go test -v -timeout 30m
```

### Run specific test
```bash
go test -v -timeout 30m -run TestTerraformAzureCAFBasicInfrastructure
```

### Run tests in parallel
```bash
go test -v -timeout 45m -parallel 3
```

## Test Structure

### `TestTerraformAzureCAFBasicInfrastructure`
- Deploys basic CAF infrastructure (resource groups)
- Validates naming conventions and tagging
- Tests core functionality

### `TestTerraformAzureCAFStorageAccountSecurity`
- Tests storage account security defaults
- Validates customer-managed key enforcement
- Checks HTTPS-only and TLS version settings
- Verifies private endpoint configurations

### `TestTerraformAzureCAFKeyVaultSecurity`
- Tests Key Vault security hardening
- Validates purge protection and soft delete
- Checks RBAC authorization settings

### `TestTerraformAzureCAFNetworkingSecurity`
- Tests virtual network configurations
- Validates subnet security settings
- Checks network security group defaults

## Security Test Scenarios

The tests validate the security enhancements implemented:

1. **Production Environment Defaults**:
   - Customer-managed keys enforced
   - Private endpoints required
   - WAF policies in Prevention mode
   - Key Vault purge protection enabled

2. **Development Environment Flexibility**:
   - Security defaults applied but relaxed
   - WAF in Detection mode
   - Shorter retention periods

3. **Cross-Environment Validation**:
   - Environment-specific configuration loading
   - Security policy enforcement checks

## Best Practices

1. **Cleanup**: Tests automatically destroy resources using `defer terraform.Destroy()`
2. **Unique Naming**: Uses random IDs to prevent naming conflicts
3. **Regional Testing**: Randomly selects Azure regions for deployment
4. **Parallel Execution**: Tests run in parallel for faster execution
5. **Error Handling**: Comprehensive error checking and assertions

## Troubleshooting

### Common Issues

1. **Timeout Errors**: Increase timeout values for complex deployments
2. **Permission Errors**: Ensure proper RBAC permissions in Azure subscription
3. **Naming Conflicts**: Tests use unique IDs, but manual cleanup may be needed if tests fail
4. **Resource Limits**: Be aware of Azure subscription limits

### Cleanup Failed Resources

If tests fail and leave resources behind:

```bash
# List resource groups with test prefix
az group list --query "[?starts_with(name, 'rg-caf-test')]" --output table

# Delete specific resource group
az group delete --name "rg-caf-test-<unique-id>" --yes --no-wait
```

## Integration with CI/CD

Add to GitHub Actions or Azure DevOps:

```yaml
- name: Run Terratest
  run: |
    cd test
    go mod tidy
    go test -v -timeout 45m -parallel 2
  env:
    ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
    ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
    ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
    ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
```

## Contributing

When adding new tests:

1. Follow existing naming conventions
2. Use `t.Parallel()` for concurrent execution
3. Include proper cleanup with `defer terraform.Destroy()`
4. Add comprehensive assertions
5. Update this README with new test descriptions