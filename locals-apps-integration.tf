# Application and Integration Services local values
# Web apps, API management, logic apps, messaging, and integration services

locals {
  # Web application services
  webapp = {
    app_service_environments                       = try(var.webapp.app_service_environments, {})
    app_service_environments_v3                    = try(var.webapp.app_service_environments_v3, {})
    app_service_plans                              = try(var.webapp.app_service_plans, {})
    app_services                                   = try(var.webapp.app_services, {})
    azurerm_application_insights                   = try(var.webapp.azurerm_application_insights, {})
    azurerm_application_insights_web_test          = try(var.webapp.azurerm_application_insights_web_test, {})
    azurerm_application_insights_standard_web_test = try(var.webapp.azurerm_application_insights_standard_web_test, {})
    function_apps                                  = try(var.webapp.function_apps, {})
    static_sites                                   = try(var.webapp.static_sites, {})
  }

  # API Management services
  apim = {
    api_management                      = try(var.apim.api_management, {})
    api_management_api                  = try(var.apim.api_management_api, {})
    api_management_api_diagnostic       = try(var.apim.api_management_api_diagnostic, {})
    api_management_logger               = try(var.apim.api_management_logger, {})
    api_management_api_operation        = try(var.apim.api_management_api_operation, {})
    api_management_backend              = try(var.apim.api_management_backend, {})
    api_management_api_policy           = try(var.apim.api_management_api_policy, {})
    api_management_api_operation_tag    = try(var.apim.api_management_api_operation_tag, {})
    api_management_api_operation_policy = try(var.apim.api_management_api_operation_policy, {})
    api_management_user                 = try(var.apim.api_management_user, {})
    api_management_custom_domain        = try(var.apim.api_management_custom_domain, {})
    api_management_diagnostic           = try(var.apim.api_management_diagnostic, {})
    api_management_certificate          = try(var.apim.api_management_certificate, {})
    api_management_gateway              = try(var.apim.api_management_gateway, {})
    api_management_gateway_api          = try(var.apim.api_management_gateway_api, {})
    api_management_group                = try(var.apim.api_management_group, {})
    api_management_subscription         = try(var.apim.api_management_subscription, {})
    api_management_product              = try(var.apim.api_management_product, {})
  }

  # Logic Apps and workflow automation
  logic_app = {
    integration_service_environment = try(var.logic_app.integration_service_environment, {})
    logic_app_action_custom         = try(var.logic_app.logic_app_action_custom, {})
    logic_app_action_http           = try(var.logic_app.logic_app_action_http, {})
    logic_app_integration_account   = try(var.logic_app.logic_app_integration_account, {})
    logic_app_trigger_custom        = try(var.logic_app.logic_app_trigger_custom, {})
    logic_app_trigger_http_request  = try(var.logic_app.logic_app_trigger_http_request, {})
    logic_app_trigger_recurrence    = try(var.logic_app.logic_app_trigger_recurrence, {})
    logic_app_workflow              = try(var.logic_app.logic_app_workflow, {})
    logic_app_standard              = try(var.logic_app.logic_app_standard, {})
  }

  # Messaging and event-driven services
  messaging = {
    signalr_services                    = try(var.messaging.signalr_services, {})
    servicebus_namespaces               = try(var.messaging.servicebus_namespaces, {})
    servicebus_queues                   = try(var.messaging.servicebus_queues, {})
    servicebus_topics                   = try(var.messaging.servicebus_topics, {})
    eventgrid_domain                    = try(var.messaging.eventgrid_domain, {})
    eventgrid_topic                     = try(var.messaging.eventgrid_topic, {})
    eventgrid_event_subscription        = try(var.messaging.eventgrid_event_subscription, {})
    eventgrid_domain_topic              = try(var.messaging.eventgrid_domain_topic, {})
    eventgrid_system_topic              = try(var.messaging.eventgrid_system_topic, {})
    eventgrid_system_event_subscription = try(var.messaging.eventgrid_system_event_subscription, {})
    web_pubsubs                         = try(var.messaging.web_pubsubs, {})
    web_pubsub_hubs                     = try(var.messaging.web_pubsub_hubs, {})
  }

  # Communication Services for SMS, voice, chat, email
  communication = {
    communication_services = try(var.communication.communication_services, {})
  }
}