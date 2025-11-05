# AWS Well-Architected Framework - Global Variables

# Global Settings
variable "global_settings" {
  description = "Global settings for the AWS Well-Architected deployment"
  type = object({
    organization_name = string
    environment      = string
    project_name     = string
    cost_center      = string
    owner           = string
    passthrough     = optional(bool, false)
    random_length   = optional(number, 4)

    # Multi-region configuration
    primary_region   = optional(string, "us-east-1")
    secondary_region = optional(string, "us-west-2")

    # Multi-account configuration
    enable_organizations = optional(bool, false)

    tags = optional(map(string), {})
  })

  default = {
    organization_name = "example-org"
    environment      = "dev"
    project_name     = "well-architected"
    cost_center      = "engineering"
    owner           = "platform-team"
  }

  validation {
    condition = contains(["dev", "test", "staging", "production"], var.global_settings.environment)
    error_message = "Environment must be one of: dev, test, staging, production."
  }
}

# Well-Architected Pillars Configuration
variable "pillars" {
  description = "Configuration for AWS Well-Architected Framework pillars"
  type = object({
    operational_excellence = optional(bool, true)
    security              = optional(bool, true)
    reliability           = optional(bool, true)
    performance_efficiency = optional(bool, true)
    cost_optimization     = optional(bool, true)
    sustainability        = optional(bool, true)
  })

  default = {
    operational_excellence = true
    security              = true
    reliability           = true
    performance_efficiency = true
    cost_optimization     = true
    sustainability        = true
  }
}

# Account Configuration
variable "account_config" {
  description = "AWS account configuration settings"
  type = object({
    primary_account_id   = optional(string)
    logging_account_id   = optional(string)
    security_account_id  = optional(string)
    management_account_id = optional(string)
    enable_cross_account = optional(bool, false)
  })

  default = {
    enable_cross_account = false
  }
}

# Networking Configuration
variable "networking" {
  description = "Network infrastructure configuration"
  type = object({
    vpc_cidr             = optional(string, "10.0.0.0/16")
    enable_dns_hostnames = optional(bool, true)
    enable_dns_support   = optional(bool, true)
    enable_nat_gateway   = optional(bool, true)
    enable_vpn_gateway   = optional(bool, false)

    # Subnet configuration
    availability_zones = optional(list(string), [])

    # Security groups
    enable_flow_logs = optional(bool, true)

    # Advanced networking
    enable_transit_gateway = optional(bool, false)
    enable_direct_connect = optional(bool, false)
  })

  default = {}
}

# Operational Excellence Pillar Variables
variable "operational_excellence" {
  description = "Operational Excellence pillar configuration"
  type = object({
    # Monitoring and Observability
    enable_cloudwatch     = optional(bool, true)
    enable_xray          = optional(bool, true)
    enable_cloudtrail    = optional(bool, true)

    # Automation
    enable_systems_manager = optional(bool, true)
    enable_config         = optional(bool, true)

    # Application Performance Monitoring
    enable_application_insights = optional(bool, true)

    # Event Management
    enable_eventbridge = optional(bool, true)

    # Change Management
    enable_codepipeline = optional(bool, false)
    enable_codebuild   = optional(bool, false)
  })

  default = {}
}

# Security Pillar Variables
variable "security" {
  description = "Security pillar configuration"
  type = object({
    # Identity and Access Management
    enable_organizations = optional(bool, false)
    enable_sso          = optional(bool, false)

    # Data Protection
    enable_kms          = optional(bool, true)
    enable_secrets_manager = optional(bool, true)

    # Threat Detection and Incident Response
    enable_guardduty    = optional(bool, true)
    enable_security_hub = optional(bool, true)
    enable_inspector    = optional(bool, true)
    enable_macie       = optional(bool, false)

    # Infrastructure Protection
    enable_waf         = optional(bool, true)
    enable_shield      = optional(bool, false)

    # Compliance and Governance
    enable_config      = optional(bool, true)
    enable_cloudtrail  = optional(bool, true)

    # Network Security
    enable_vpc_flow_logs = optional(bool, true)
  })

  default = {}
}

# Reliability Pillar Variables
variable "reliability" {
  description = "Reliability pillar configuration"
  type = object({
    # Foundations
    enable_multi_az = optional(bool, true)

    # Change Management
    enable_auto_scaling = optional(bool, true)

    # Failure Management
    enable_backup = optional(bool, true)
    enable_disaster_recovery = optional(bool, false)

    # Load Balancing
    enable_application_load_balancer = optional(bool, true)
    enable_network_load_balancer    = optional(bool, false)

    # Database Reliability
    enable_rds_multi_az = optional(bool, true)
    enable_aurora      = optional(bool, false)

    # Monitoring and Recovery
    enable_cloudwatch_alarms = optional(bool, true)
    enable_sns_notifications = optional(bool, true)
  })

  default = {}
}

# Performance Efficiency Pillar Variables
variable "performance_efficiency" {
  description = "Performance Efficiency pillar configuration"
  type = object({
    # Compute
    enable_ec2_optimization = optional(bool, true)
    enable_lambda         = optional(bool, true)
    enable_fargate        = optional(bool, false)

    # Storage
    enable_s3_optimization = optional(bool, true)
    enable_efs            = optional(bool, false)

    # Database
    enable_database_optimization = optional(bool, true)
    enable_elasticache          = optional(bool, false)

    # Networking
    enable_cloudfront = optional(bool, true)
    enable_route53   = optional(bool, true)

    # Content Delivery
    enable_s3_transfer_acceleration = optional(bool, false)
  })

  default = {}
}

# Cost Optimization Pillar Variables
variable "cost_optimization" {
  description = "Cost Optimization pillar configuration"
  type = object({
    # Expenditure Awareness
    enable_cost_explorer = optional(bool, true)
    enable_budgets      = optional(bool, true)

    # Cost-Effective Resources
    enable_reserved_instances = optional(bool, false)
    enable_savings_plans     = optional(bool, false)
    enable_spot_instances    = optional(bool, false)

    # Matching Supply and Demand
    enable_auto_scaling = optional(bool, true)

    # Optimizing Over Time
    enable_trusted_advisor = optional(bool, true)
    enable_compute_optimizer = optional(bool, true)

    # Cost Allocation
    enable_cost_allocation_tags = optional(bool, true)
  })

  default = {}
}

# Sustainability Pillar Variables
variable "sustainability" {
  description = "Sustainability pillar configuration"
  type = object({
    # Optimization Patterns
    enable_carbon_footprint_tracking = optional(bool, true)
    enable_sustainability_insights  = optional(bool, true)

    # Resource Efficiency
    enable_right_sizing = optional(bool, true)
    enable_graviton     = optional(bool, false)

    # Renewable Energy
    prefer_renewable_energy_regions = optional(bool, true)

    # Lifecycle Management
    enable_resource_lifecycle = optional(bool, true)
  })

  default = {}
}

# Compute Resources
variable "compute" {
  description = "Compute resources configuration"
  type = object({
    # EC2
    ec2_instances = optional(map(any), {})

    # Auto Scaling
    auto_scaling_groups = optional(map(any), {})

    # Lambda
    lambda_functions = optional(map(any), {})

    # ECS/Fargate
    ecs_services = optional(map(any), {})

    # EKS
    eks_clusters = optional(map(any), {})
  })

  default = {}
}

# Database Resources
variable "databases" {
  description = "Database resources configuration"
  type = object({
    # RDS
    rds_instances = optional(map(any), {})

    # Aurora
    aurora_clusters = optional(map(any), {})

    # DynamoDB
    dynamodb_tables = optional(map(any), {})

    # DocumentDB
    documentdb_clusters = optional(map(any), {})

    # ElastiCache
    elasticache_clusters = optional(map(any), {})
  })

  default = {}
}

# Storage Resources
variable "storage" {
  description = "Storage resources configuration"
  type = object({
    # S3
    s3_buckets = optional(map(any), {})

    # EFS
    efs_file_systems = optional(map(any), {})

    # EBS
    ebs_volumes = optional(map(any), {})

    # FSx
    fsx_file_systems = optional(map(any), {})
  })

  default = {}
}

# Monitoring and Logging
variable "monitoring" {
  description = "Monitoring and logging configuration"
  type = object({
    # CloudWatch
    cloudwatch_log_groups = optional(map(any), {})
    cloudwatch_dashboards = optional(map(any), {})
    cloudwatch_alarms     = optional(map(any), {})

    # X-Ray
    enable_xray_tracing = optional(bool, false)

    # Application Insights
    application_insights = optional(map(any), {})
  })

  default = {}
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}