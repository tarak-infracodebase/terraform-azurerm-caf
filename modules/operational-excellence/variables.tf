# Operational Excellence Pillar Variables

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "account_config" {
  description = "Account configuration"
  type = object({
    current_account_id = string
    current_region     = string
  })
}

variable "vpc_id" {
  description = "VPC ID for resources that need it"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs for resources that need them"
  type = object({
    public   = list(string)
    private  = list(string)
    database = list(string)
  })
  default = {
    public   = []
    private  = []
    database = []
  }
}

variable "enable_cloudwatch" {
  description = "Enable CloudWatch monitoring"
  type        = bool
  default     = true
}

variable "enable_xray" {
  description = "Enable AWS X-Ray tracing"
  type        = bool
  default     = true
}

variable "enable_cloudtrail" {
  description = "Enable AWS CloudTrail"
  type        = bool
  default     = true
}

variable "enable_systems_manager" {
  description = "Enable AWS Systems Manager"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable AWS Config"
  type        = bool
  default     = true
}

variable "enable_application_insights" {
  description = "Enable Application Insights"
  type        = bool
  default     = true
}

variable "enable_eventbridge" {
  description = "Enable EventBridge for event-driven architecture"
  type        = bool
  default     = true
}

variable "monitoring_config" {
  description = "Monitoring configuration"
  type = object({
    log_retention_days       = number
    detailed_monitoring_enabled = bool
    alarm_actions_enabled    = bool
  })
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "operations_email" {
  description = "Email address for operational notifications"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}