# Cost Optimization Dashboard and Monitoring
# This module creates dashboards, budgets, and alerts for cost optimization

# Azure Cost Management Budget at Resource Group Level
resource "azurerm_consumption_budget_resource_group" "cost_budget" {
  for_each = var.cost_budgets

  name              = each.value.name
  resource_group_id = each.value.resource_group_id
  amount            = each.value.amount
  time_grain        = try(each.value.time_grain, "Monthly")

  time_period {
    start_date = try(each.value.start_date, formatdate("YYYY-MM-01", timestamp()))
    end_date   = try(each.value.end_date, null)
  }

  dynamic "notification" {
    for_each = each.value.notifications

    content {
      enabled        = notification.value.enabled
      threshold      = notification.value.threshold
      operator       = notification.value.operator
      threshold_type = try(notification.value.threshold_type, "Actual")
      contact_emails = notification.value.contact_emails
    }
  }

  dynamic "filter" {
    for_each = try(each.value.filter, null) != null ? [each.value.filter] : []

    content {
      dynamic "dimension" {
        for_each = try(filter.value.dimensions, [])

        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }

      dynamic "tag" {
        for_each = try(filter.value.tags, [])

        content {
          name     = tag.value.name
          operator = tag.value.operator
          values   = tag.value.values
        }
      }
    }
  }

  tags = merge(var.base_tags, {
    cost_optimization = {
      type    = "budget_monitoring"
      purpose = "cost_control"
    }
  })
}

# Log Analytics Workspace for Cost Optimization Insights
resource "azurerm_log_analytics_workspace" "cost_optimization" {
  count = var.enable_cost_analytics ? 1 : 0

  name                = "${var.global_settings.prefix}-cost-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 90

  tags = merge(var.base_tags, {
    cost_optimization = {
      type                = "cost_analytics"
      estimated_cost_usd  = "100-500"
      purpose            = "cost_monitoring"
    }
  })
}

# Cost Optimization Alerts
resource "azurerm_monitor_metric_alert" "high_cost_resources" {
  for_each = var.cost_alerts

  name                = each.value.name
  resource_group_name = var.resource_group_name
  scopes              = each.value.scopes
  description         = each.value.description
  severity            = try(each.value.severity, 2)
  frequency           = try(each.value.frequency, "PT5M")
  window_size         = try(each.value.window_size, "PT15M")

  criteria {
    metric_namespace = "Microsoft.CostManagement/accounts"
    metric_name      = "ActualCost"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = each.value.cost_threshold
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = merge(var.base_tags, {
    alert_type = "cost_optimization"
  })
}

# Automated Right-Sizing Recommendations
# This creates custom queries in Log Analytics to identify optimization opportunities
resource "azurerm_log_analytics_saved_search" "cost_optimization_queries" {
  count = var.enable_cost_analytics ? 1 : 0

  name                       = "cost-optimization-queries"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cost_optimization[0].id
  category                   = "Cost Optimization"
  display_name               = "Cost Optimization Recommendations"
  query                      = <<-EOT
// VMs with low CPU utilization (candidates for downsizing)
Perf
| where CounterName == "% Processor Time" and InstanceName == "_Total"
| where CounterValue < 20  // Less than 20% average CPU
| summarize AvgCPU = avg(CounterValue) by Computer
| join kind=inner (
    Heartbeat
    | summarize by Computer, ResourceGroup, SubscriptionId
) on Computer
| extend Recommendation = "Consider downsizing VM due to low CPU utilization"
| extend EstimatedSavings = "20-50%"
| project Computer, ResourceGroup, AvgCPU, Recommendation, EstimatedSavings

EOT
}

# Cost Anomaly Detection using KQL
resource "azurerm_log_analytics_saved_search" "cost_anomalies" {
  count = var.enable_cost_analytics ? 1 : 0

  name                       = "cost-anomaly-detection"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cost_optimization[0].id
  category                   = "Cost Optimization"
  display_name               = "Cost Anomaly Detection"
  query                      = <<-EOT
// Detect unusual cost spikes (more than 50% increase from previous week)
let CostData = Usage
| where TimeGenerated >= ago(14d)
| where IsBillable == true
| summarize TotalCost = sum(Quantity * EstimatedCost) by bin(TimeGenerated, 1d), ResourceGroup
| sort by TimeGenerated desc;

CostData
| extend PreviousWeekCost = prev(TotalCost, 7)
| extend CostIncrease = (TotalCost - PreviousWeekCost) / PreviousWeekCost * 100
| where CostIncrease > 50
| project TimeGenerated, ResourceGroup, TotalCost, PreviousWeekCost, CostIncrease
| extend Alert = "Unusual cost spike detected"
| sort by CostIncrease desc

EOT
}

# Storage Optimization Query
resource "azurerm_log_analytics_saved_search" "storage_optimization" {
  count = var.enable_cost_analytics ? 1 : 0

  name                       = "storage-optimization"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cost_optimization[0].id
  category                   = "Cost Optimization"
  display_name               = "Storage Optimization Opportunities"
  query                      = <<-EOT
// Identify storage accounts with infrequently accessed data
StorageBlobLogs
| where TimeGenerated >= ago(30d)
| where OperationName in ("GetBlob", "GetBlobProperties")
| summarize LastAccess = max(TimeGenerated), AccessCount = count() by Uri
| where LastAccess < ago(30d) and AccessCount < 10
| extend Recommendation = "Consider moving to Cool or Archive tier"
| extend EstimatedSavings = "46-89%"
| project Uri, LastAccess, AccessCount, Recommendation, EstimatedSavings
| sort by LastAccess asc

EOT
}

# Output important information for users
output "cost_budgets" {
  value = azurerm_consumption_budget_resource_group.cost_budget
}

output "cost_analytics_workspace" {
  value = var.enable_cost_analytics ? azurerm_log_analytics_workspace.cost_optimization[0] : null
}