variable "cost_budgets" {
  description = "Configuration for Azure Cost Management budgets"
  type = map(object({
    name              = string
    resource_group_id = string
    amount            = number
    time_grain        = optional(string, "Monthly")
    start_date        = optional(string)
    end_date          = optional(string)

    notifications = map(object({
      enabled        = bool
      threshold      = number
      operator       = string
      threshold_type = optional(string, "Actual")
      contact_emails = list(string)
    }))

    filter = optional(object({
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), [])
      tags = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), [])
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for budget in values(var.cost_budgets) :
      budget.amount > 0 && budget.amount <= 1000000
    ])
    error_message = "Budget amount must be between 1 and 1,000,000."
  }
}

variable "cost_alerts" {
  description = "Configuration for cost-based metric alerts"
  type = map(object({
    name           = string
    scopes         = list(string)
    description    = string
    severity       = optional(number, 2)
    cost_threshold = number
    frequency      = optional(string, "PT5M")
    window_size    = optional(string, "PT15M")
  }))
  default = {}
}

variable "enable_cost_analytics" {
  description = "Enable Log Analytics workspace for cost optimization insights"
  type        = bool
  default     = false
}

variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefix = string
  })
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "action_group_id" {
  description = "Action group ID for alert notifications"
  type        = string
  default     = ""
}

variable "base_tags" {
  description = "Base tags for all resources"
  type        = map(string)
  default     = {}
}

# Cost optimization recommendations configuration
variable "cost_optimization_settings" {
  description = "Settings for automated cost optimization recommendations"
  type = object({
    cpu_threshold_percent           = optional(number, 20)  # VMs with < 20% CPU usage
    memory_threshold_percent        = optional(number, 30)  # VMs with < 30% memory usage
    storage_access_threshold_days   = optional(number, 30)  # Storage not accessed in 30+ days
    disk_utilization_threshold_pct  = optional(number, 80)  # Disks with < 80% usage
    enable_automated_recommendations = optional(bool, true)
    notification_email              = optional(string, "")
  })
  default = {}
}

variable "reserved_instance_recommendations" {
  description = "Configuration for Reserved Instance purchase recommendations"
  type = object({
    enabled                    = optional(bool, true)
    minimum_monthly_cost_usd   = optional(number, 100)  # Only recommend RI for resources > $100/month
    minimum_utilization_pct    = optional(number, 75)   # Only recommend if > 75% utilization
    lookback_period_days       = optional(number, 30)   # Analyze last 30 days
    term_preference            = optional(string, "3_year") # "1_year" or "3_year"
  })
  default = {
    enabled                  = true
    minimum_monthly_cost_usd = 100
    minimum_utilization_pct  = 75
    lookback_period_days     = 30
    term_preference          = "3_year"
  }
}