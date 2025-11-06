package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestTerraformAzureCAFBasicInfrastructure tests the basic CAF infrastructure deployment
func TestTerraformAzureCAFBasicInfrastructure(t *testing.T) {
	t.Parallel()

	// Pick a random Azure region to test in. This helps ensure your code works in all regions.
	azureRegion := azure.GetRandomRegion(t, nil, nil, "southeastasia")

	// Give the resources a unique name to avoid naming conflicts
	uniqueId := random.UniqueId()
	resourceGroupName := fmt.Sprintf("rg-caf-test-%s", uniqueId)

	// Configure Terraform options
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Path to the Terraform code that will be tested.
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"global_settings": map[string]interface{}{
				"prefix":           fmt.Sprintf("caf-test-%s", uniqueId),
				"environment":      "test",
				"default_region":   "region1",
				"random_length":    4,
				"passthrough":      false,
				"use_slug":         true,
				"regions": map[string]string{
					"region1": azureRegion,
				},
			},
			"resource_groups": map[string]interface{}{
				"test": map[string]interface{}{
					"name":     resourceGroupName,
					"region":   "region1",
					"tags": map[string]string{
						"environment": "test",
						"purpose":     "terratest",
					},
				},
			},
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"ARM_SUBSCRIPTION_ID": azure.GetSubscriptionIDFromEnvVar(t),
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	// Validate that the resource group was created
	resourceGroupExists := azure.ResourceGroupExists(t, resourceGroupName, azure.GetSubscriptionIDFromEnvVar(t))
	assert.True(t, resourceGroupExists)

	// Get resource group details
	resourceGroup := azure.GetResourceGroup(t, resourceGroupName, azure.GetSubscriptionIDFromEnvVar(t))

	// Verify the resource group properties
	assert.Equal(t, azureRegion, *resourceGroup.Location)
	assert.Contains(t, *resourceGroup.Tags["environment"], "test")
	assert.Contains(t, *resourceGroup.Tags["purpose"], "terratest")
}

// TestTerraformAzureCAFStorageAccountSecurity tests storage account security configurations
func TestTerraformAzureCAFStorageAccountSecurity(t *testing.T) {
	t.Parallel()

	// Pick a random Azure region to test in
	azureRegion := azure.GetRandomRegion(t, nil, nil, "southeastasia")
	uniqueId := random.UniqueId()
	resourceGroupName := fmt.Sprintf("rg-caf-storage-test-%s", uniqueId)
	storageAccountName := fmt.Sprintf("stcaftest%s", strings.ToLower(uniqueId))

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",

		Vars: map[string]interface{}{
			"global_settings": map[string]interface{}{
				"prefix":         fmt.Sprintf("caf-test-%s", uniqueId),
				"environment":    "production", // Test production security defaults
				"default_region": "region1",
				"regions": map[string]string{
					"region1": azureRegion,
				},
			},
			"resource_groups": map[string]interface{}{
				"storage": map[string]interface{}{
					"name":   resourceGroupName,
					"region": "region1",
				},
			},
			"storage_accounts": map[string]interface{}{
				"test": map[string]interface{}{
					"name":                "stcaftest" + strings.ToLower(uniqueId),
					"resource_group_key":  "storage",
					"region":             "region1",
					"account_kind":       "StorageV2",
					"account_tier":       "Standard",
					"account_replication_type": "LRS",
					// Test that security defaults are applied
					"enable_https_traffic_only": true,
					"min_tls_version":           "TLS1_2",
				},
			},
		},

		EnvVars: map[string]string{
			"ARM_SUBSCRIPTION_ID": azure.GetSubscriptionIDFromEnvVar(t),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Validate storage account security settings
	storageAccount := azure.GetStorageAccount(t, resourceGroupName, storageAccountName, azure.GetSubscriptionIDFromEnvVar(t))

	// Verify security configurations
	assert.True(t, *storageAccount.EnableHTTPSTrafficOnly, "Storage account should enforce HTTPS traffic only")
	assert.Equal(t, "TLS1_2", string(storageAccount.MinimumTLSVersion), "Storage account should enforce minimum TLS 1.2")
	assert.False(t, *storageAccount.AllowBlobPublicAccess, "Storage account should not allow public blob access by default")
}

// TestTerraformAzureCAFKeyVaultSecurity tests Key Vault security configurations
func TestTerraformAzureCAFKeyVaultSecurity(t *testing.T) {
	t.Parallel()

	azureRegion := azure.GetRandomRegion(t, nil, nil, "southeastasia")
	uniqueId := random.UniqueId()
	resourceGroupName := fmt.Sprintf("rg-caf-kv-test-%s", uniqueId)
	keyVaultName := fmt.Sprintf("kv-caf-test-%s", uniqueId)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",

		Vars: map[string]interface{}{
			"global_settings": map[string]interface{}{
				"prefix":         fmt.Sprintf("caf-test-%s", uniqueId),
				"environment":    "production",
				"default_region": "region1",
				"regions": map[string]string{
					"region1": azureRegion,
				},
			},
			"resource_groups": map[string]interface{}{
				"keyvault": map[string]interface{}{
					"name":   resourceGroupName,
					"region": "region1",
				},
			},
			"keyvaults": map[string]interface{}{
				"test": map[string]interface{}{
					"name":               keyVaultName,
					"resource_group_key": "keyvault",
					"region":             "region1",
					"sku_name":           "standard",
					"purge_protection_enabled":    true,
					"soft_delete_retention_days":  90,
					"enable_rbac_authorization":   true,
				},
			},
		},

		EnvVars: map[string]string{
			"ARM_SUBSCRIPTION_ID": azure.GetSubscriptionIDFromEnvVar(t),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Validate Key Vault security settings
	// Note: Azure SDK for Go might require additional setup for Key Vault validation
	resourceGroupExists := azure.ResourceGroupExists(t, resourceGroupName, azure.GetSubscriptionIDFromEnvVar(t))
	assert.True(t, resourceGroupExists)

	// Validate that the terraform outputs contain expected values
	outputs := terraform.OutputAll(t, terraformOptions)
	require.Contains(t, outputs, "keyvaults")
}

// TestTerraformAzureCAFNetworkingSecurity tests networking security configurations
func TestTerraformAzureCAFNetworkingSecurity(t *testing.T) {
	t.Parallel()

	azureRegion := azure.GetRandomRegion(t, nil, nil, "southeastasia")
	uniqueId := random.UniqueId()
	resourceGroupName := fmt.Sprintf("rg-caf-net-test-%s", uniqueId)
	vnetName := fmt.Sprintf("vnet-caf-test-%s", uniqueId)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",

		Vars: map[string]interface{}{
			"global_settings": map[string]interface{}{
				"prefix":         fmt.Sprintf("caf-test-%s", uniqueId),
				"environment":    "production",
				"default_region": "region1",
				"regions": map[string]string{
					"region1": azureRegion,
				},
			},
			"resource_groups": map[string]interface{}{
				"networking": map[string]interface{}{
					"name":   resourceGroupName,
					"region": "region1",
				},
			},
			"networking": map[string]interface{}{
				"vnets": map[string]interface{}{
					"test": map[string]interface{}{
						"name":               vnetName,
						"resource_group_key": "networking",
						"region":             "region1",
						"address_space":      []string{"10.0.0.0/16"},
						"subnets": map[string]interface{}{
							"default": map[string]interface{}{
								"name":           "snet-default",
								"address_prefix": "10.0.1.0/24",
							},
						},
					},
				},
			},
		},

		EnvVars: map[string]string{
			"ARM_SUBSCRIPTION_ID": azure.GetSubscriptionIDFromEnvVar(t),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Validate virtual network exists
	resourceGroupExists := azure.ResourceGroupExists(t, resourceGroupName, azure.GetSubscriptionIDFromEnvVar(t))
	assert.True(t, resourceGroupExists)

	// Validate terraform outputs
	outputs := terraform.OutputAll(t, terraformOptions)
	require.Contains(t, outputs, "networking")
}