variable "virtual_machines" {
  description = "Map of virtual machines with their auto-shutdown configurations"
  type = map(object({
    id       = string
    location = string
    auto_shutdown = optional(object({
      enabled       = optional(bool, true)
      shutdown_time = optional(string, "1900")
      timezone      = optional(string, "UTC")
      notifications = optional(object({
        enabled         = optional(bool, false)
        time_in_minutes = optional(number, 15)
        webhook_url     = optional(string, "")
        email           = optional(string, "")
      }), {})
    }), {})
    environment = optional(string, "dev")
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "default_auto_shutdown" {
  description = "Default auto-shutdown configuration for all VMs"
  type = object({
    enabled       = optional(bool, true)
    shutdown_time = optional(string, "1900") # 7 PM UTC
    timezone      = optional(string, "UTC")
    notifications = optional(object({
      enabled         = optional(bool, false)
      time_in_minutes = optional(number, 15)
      webhook_url     = optional(string, "")
      email           = optional(string, "")
    }), {
      enabled         = false
      time_in_minutes = 15
      webhook_url     = ""
      email           = ""
    })
  })
  default = {
    enabled       = true
    shutdown_time = "1900"
    timezone      = "UTC"
    notifications = {
      enabled         = false
      time_in_minutes = 15
      webhook_url     = ""
      email           = ""
    }
  }

  validation {
    condition = can(regex("^([01]?[0-9]|2[0-3])[0-5][0-9]$", var.default_auto_shutdown.shutdown_time))
    error_message = "Shutdown time must be in HHMM format (e.g., '1900' for 7:00 PM)."
  }
}

variable "base_tags" {
  description = "Base tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "global_settings" {
  description = "Global settings object"
  type        = any
  default     = {}
}