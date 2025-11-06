# Database Services local values
# Separated for performance optimization and better organization

locals {
  database = {
    app_config                         = try(var.database.app_config, {})
    azurerm_redis_caches               = try(var.database.azurerm_redis_caches, {})
    cosmos_dbs                         = try(var.database.cosmos_dbs, {})
    cosmosdb_sql_databases             = try(var.database.cosmosdb_sql_databases, {})
    cosmosdb_role_definitions          = try(var.database.cosmosdb_role_definitions, {})
    cosmosdb_role_mapping              = try(var.database.cosmosdb_role_mapping, {})
    database_migration_services        = try(var.database.database_migration_services, {})
    database_migration_projects        = try(var.database.database_migration_projects, {})
    databricks_workspaces              = try(var.database.databricks_workspaces, {})
    databricks_access_connectors       = try(var.database.databricks_access_connectors, {})
    machine_learning_workspaces        = try(var.database.machine_learning_workspaces, {})
    mariadb_databases                  = try(var.database.mariadb_databases, {})
    mariadb_servers                    = try(var.database.mariadb_servers, {})
    mssql_databases                    = try(var.database.mssql_databases, {})
    mssql_elastic_pools                = try(var.database.mssql_elastic_pools, {})
    mssql_failover_groups              = try(var.database.mssql_failover_groups, {})
    mssql_managed_databases            = try(var.database.mssql_managed_databases, {})
    mssql_managed_databases_backup_ltr = try(var.database.mssql_managed_databases_backup_ltr, {})
    mssql_managed_databases_restore    = try(var.database.mssql_managed_databases_restore, {})
    mssql_managed_instances            = try(var.database.mssql_managed_instances, {})
    mssql_managed_instances_secondary  = try(var.database.mssql_managed_instances_secondary, {})
    mssql_mi_administrators            = try(var.database.mssql_mi_administrators, {})
    mssql_mi_failover_groups           = try(var.database.mssql_mi_failover_groups, {})
    mssql_mi_secondary_tdes            = try(var.database.mssql_mi_secondary_tdes, {})
    mssql_mi_tdes                      = try(var.database.mssql_mi_tdes, {})
    mssql_servers                      = try(var.database.mssql_servers, {})
    mysql_databases                    = try(var.database.mysql_databases, {})
    mysql_servers                      = try(var.database.mysql_servers, {})
    postgresql_flexible_servers        = try(var.database.postgresql_flexible_servers, {})
    postgresql_servers                 = try(var.database.postgresql_servers, {})
    synapse_workspaces                 = try(var.database.synapse_workspaces, {})
    mysql_flexible_server              = try(var.database.mysql_flexible_server, {})

    # Data Explorer / Kusto Services
    data_explorer = {
      kusto_clusters                         = try(var.database.data_explorer.kusto_clusters, {})
      kusto_databases                        = try(var.database.data_explorer.kusto_databases, {})
      kusto_attached_database_configurations = try(var.database.data_explorer.kusto_attached_database_configurations, {})
      kusto_cluster_customer_managed_keys    = try(var.database.data_explorer.kusto_cluster_customer_managed_keys, {})
      kusto_cluster_principal_assignments    = try(var.database.data_explorer.kusto_cluster_principal_assignments, {})
      kusto_database_principal_assignments   = try(var.database.data_explorer.kusto_database_principal_assignments, {})
      kusto_eventgrid_data_connections       = try(var.database.data_explorer.kusto_eventgrid_data_connections, {})
      kusto_eventhub_data_connections        = try(var.database.data_explorer.kusto_eventhub_data_connections, {})
      kusto_iothub_data_connections          = try(var.database.data_explorer.kusto_iothub_data_connections, {})
    }
  }
}