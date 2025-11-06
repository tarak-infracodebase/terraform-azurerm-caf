# Cloud Configuration local values
# Azure cloud endpoints and resource identifiers for different Azure environments

locals {
  # Azure cloud configuration with comprehensive endpoint definitions
  # Supports Azure Public, Government, China, and other sovereign clouds
  cloud = merge({
    # Service endpoints for different Azure clouds
    acrLoginServerEndpoint                      = try(var.cloud.acrLoginServerEndpoint, {})
    attestationEndpoint                         = try(var.cloud.attestationEndpoint, {})
    azureDatalakeAnalyticsCatalogAndJobEndpoint = try(var.cloud.azureDatalakeAnalyticsCatalogAndJobEndpoint, {})
    azureDatalakeStoreFileSystemEndpoint        = try(var.cloud.azureDatalakeStoreFileSystemEndpoint, {})
    keyvaultDns                                 = try(var.cloud.keyvaultDns, {})
    mariadbServerEndpoint                       = try(var.cloud.mariadbServerEndpoint, {})
    mhsmDns                                     = try(var.cloud.mhsmDns, {})
    mysqlServerEndpoint                         = try(var.cloud.mysqlServerEndpoint, {})
    postgresqlServerEndpoint                    = try(var.cloud.postgresqlServerEndpoint, {})
    sqlServerHostname                           = try(var.cloud.sqlServerHostname, {})
    storageEndpoint                             = try(var.cloud.storageEndpoint, {})
    storageSyncEndpoint                         = try(var.cloud.storageSyncEndpoint, {})
    synapseAnalyticsEndpoint                    = try(var.cloud.synapseAnalyticsEndpoint, {})

    # Azure Resource Manager and authentication endpoints
    activeDirectory                             = try(var.cloud.activeDirectory, {})
    activeDirectoryDataLakeResourceId           = try(var.cloud.activeDirectoryDataLakeResourceId, {})
    activeDirectoryGraphResourceId              = try(var.cloud.activeDirectoryGraphResourceId, {})
    activeDirectoryResourceId                   = try(var.cloud.activeDirectoryResourceId, {})
    appInsightsResourceId                       = try(var.cloud.appInsightsResourceId, {})
    appInsightsTelemetryChannelResourceId       = try(var.cloud.appInsightsTelemetryChannelResourceId, {})
    attestationResourceId                       = try(var.cloud.attestationResourceId, {})
    azmirrorStorageAccountResourceId            = try(var.cloud.azmirrorStorageAccountResourceId, {})
    batchResourceId                             = try(var.cloud.batchResourceId, {})
    gallery                                     = try(var.cloud.gallery, {})
    logAnalyticsResourceId                      = try(var.cloud.logAnalyticsResourceId, {})
    management                                  = try(var.cloud.management, {})
    mediaResourceId                             = try(var.cloud.mediaResourceId, {})
    microsoftGraphResourceId                    = try(var.cloud.microsoftGraphResourceId, {})
    ossrdbmsResourceId                          = try(var.cloud.ossrdbmsResourceId, {})
    portal                                      = try(var.cloud.portal, {})
    resourceManager                             = try(var.cloud.resourceManager, {})
    sqlManagement                               = try(var.cloud.sqlManagement, {})
    synapseAnalyticsResourceId                  = try(var.cloud.synapseAnalyticsResourceId, {})
    vmImageAliasDoc                             = try(var.cloud.vmImageAliasDoc, {})
  }, var.cloud)
}