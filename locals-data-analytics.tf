# Data and Analytics Services local values
# Data Factory, IoT, specialized analytics, and AI services

locals {
  # Azure Data Factory for ETL/ELT pipelines
  data_factory = {
    data_factory                                 = try(var.data_factory.data_factory, {})
    data_factory_pipeline                        = try(var.data_factory.data_factory_pipeline, {})
    data_factory_trigger_schedule                = try(var.data_factory.data_factory_trigger_schedule, {})
    data_factory_integration_runtime_azure_ssis  = try(var.data_factory.data_factory_integration_runtime_azure_ssis, {})
    data_factory_integration_runtime_self_hosted = try(var.data_factory.data_factory_integration_runtime_self_hosted, {})

    # Data Factory datasets for various data sources
    datasets = {
      azure_blob       = try(var.data_factory.datasets.azure_blob, {})
      cosmosdb_sqlapi  = try(var.data_factory.datasets.cosmosdb_sqlapi, {})
      delimited_text   = try(var.data_factory.datasets.delimited_text, {})
      http             = try(var.data_factory.datasets.http, {})
      json             = try(var.data_factory.datasets.json, {})
      mysql            = try(var.data_factory.datasets.mysql, {})
      postgresql       = try(var.data_factory.datasets.postgresql, {})
      sql_server_table = try(var.data_factory.datasets.sql_server_table, {})
    }

    # Data Factory linked services for external connections
    linked_services = {
      azure_blob_storage = try(var.data_factory.linked_services.azure_blob_storage, {})
      azure_databricks   = try(var.data_factory.linked_services.azure_databricks, {})
      cosmosdb           = try(var.data_factory.linked_services.cosmosdb, {})
      key_vault          = try(var.data_factory.linked_services.key_vault, {})
      mysql              = try(var.data_factory.linked_services.mysql, {})
      postgresql         = try(var.data_factory.linked_services.postgresql, {})
      sql_server         = try(var.data_factory.linked_services.sql_server, {})
      web                = try(var.data_factory.linked_services.web, {})
    }
  }

  # Internet of Things (IoT) services
  iot = {
    digital_twins_instances             = try(var.iot.digital_twins_instances, {})
    digital_twins_endpoint_eventhubs    = try(var.iot.digital_twins_endpoint_eventhubs, {})
    digital_twins_endpoint_eventgrids   = try(var.iot.digital_twins_endpoint_eventgrids, {})
    digital_twins_endpoint_servicebuses = try(var.iot.digital_twins_endpoint_servicebuses, {})
    iot_hub                             = try(var.iot.iot_hub, {})
    iot_hub_consumer_groups             = try(var.iot.iot_hub_consumer_groups, {})
    iot_hub_certificate                 = try(var.iot.iot_hub_certificate, {})
    iot_hub_shared_access_policy        = try(var.iot.iot_hub_shared_access_policy, {})
    iot_hub_dps                         = try(var.iot.iot_hub_dps, {})
    iot_dps_certificate                 = try(var.iot.iot_dps_certificate, {})
    iot_dps_shared_access_policy        = try(var.iot.iot_dps_shared_access_policy, {})
    iot_security_solution               = try(var.iot.iot_security_solution, {})
    iot_security_device_group           = try(var.iot.iot_security_device_group, {})
    iot_central_application             = try(var.iot.iot_central_application, {})
  }

  # Artificial Intelligence and Cognitive Services
  cognitive_services = {
    cognitive_services_account = try(var.cognitive_services.cognitive_services_account, {})
  }

  # Azure Search Services
  search_services = {
    search_services = try(var.search_services.search_services, {})
  }

  # Azure Maps for location services
  maps = {
    maps_accounts = try(var.maps.maps_accounts, {})
  }

  # Microsoft Purview for data governance and compliance
  purview = {
    purview_accounts = try(var.purview.purview_accounts, {})
  }

  # Power BI Embedded for analytics
  powerbi_embedded = try(var.powerbi_embedded, {})

  # Azure Load Testing
  load_test = try(var.load_test, {})
}