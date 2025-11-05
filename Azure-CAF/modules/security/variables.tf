# Security Pillar Variables

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
  description = "VPC ID for security groups and flow logs"
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

variable "enable_kms" {
  description = "Enable KMS key management"
  type        = bool
  default     = true
}

variable "enable_secrets_manager" {
  description = "Enable AWS Secrets Manager"
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Enable Amazon GuardDuty"
  type        = bool
  default     = true
}

variable "enable_security_hub" {
  description = "Enable AWS Security Hub"
  type        = bool
  default     = true
}

variable "enable_inspector" {
  description = "Enable Amazon Inspector"
  type        = bool
  default     = true
}

variable "enable_waf" {
  description = "Enable AWS WAF"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable AWS Config for security compliance"
  type        = bool
  default     = true
}

variable "enable_cloudtrail" {
  description = "Enable CloudTrail for security logging"
  type        = bool
  default     = true
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "security_config" {
  description = "Security configuration settings"
  type = object({
    kms_key_deletion_window             = number
    enable_kms_key_rotation            = bool
    secret_recovery_window_days        = number
    guardduty_enable_s3_protection     = bool
    guardduty_enable_kubernetes_protection = bool
    guardduty_enable_malware_protection = bool
    vpc_flow_logs_traffic_type         = string
    vpc_flow_logs_retention           = number
    waf_default_action               = string
  })
}

variable "cloudwatch_log_groups" {
  description = "CloudWatch log groups for cross-pillar integration"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}