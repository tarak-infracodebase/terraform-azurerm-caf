# AWS Well-Architected Framework - Local Values

locals {
  # Generate random string for unique resource naming if not in passthrough mode
  random_string = var.global_settings.passthrough ? "" : random_string.prefix[0].result

  # Common tags applied to all resources
  common_tags = merge(
    {
      Environment         = var.global_settings.environment
      Organization        = var.global_settings.organization_name
      Project            = var.global_settings.project_name
      CostCenter         = var.global_settings.cost_center
      Owner              = var.global_settings.owner
      ManagedBy          = "Terraform"
      WellArchitected    = "true"
      CreatedDate        = timestamp()
    },
    var.global_settings.tags,
    var.additional_tags
  )

  # Resource naming convention
  name_prefix = var.global_settings.passthrough ? var.global_settings.project_name : "${var.global_settings.project_name}-${local.random_string}"

  # Multi-region configuration
  regions = {
    primary   = var.global_settings.primary_region
    secondary = var.global_settings.secondary_region
  }

  # Account configuration
  account_config = {
    current_account_id    = data.aws_caller_identity.current.account_id
    current_region        = data.aws_region.current.name
    current_partition     = data.aws_partition.current.partition
    primary_account_id    = try(var.account_config.primary_account_id, data.aws_caller_identity.current.account_id)
    logging_account_id    = try(var.account_config.logging_account_id, data.aws_caller_identity.current.account_id)
    security_account_id   = try(var.account_config.security_account_id, data.aws_caller_identity.current.account_id)
    management_account_id = try(var.account_config.management_account_id, data.aws_caller_identity.current.account_id)
  }

  # Availability zones
  availability_zones = length(var.networking.availability_zones) > 0 ? var.networking.availability_zones : slice(data.aws_availability_zones.available.names, 0, 3)

  # Subnet CIDR calculation
  subnet_cidrs = {
    public = [
      for i, az in local.availability_zones :
      cidrsubnet(var.networking.vpc_cidr, 4, i)
    ]
    private = [
      for i, az in local.availability_zones :
      cidrsubnet(var.networking.vpc_cidr, 4, i + length(local.availability_zones))
    ]
    database = [
      for i, az in local.availability_zones :
      cidrsubnet(var.networking.vpc_cidr, 4, i + (2 * length(local.availability_zones)))
    ]
  }

  # Well-Architected Pillars
  enabled_pillars = {
    operational_excellence = var.pillars.operational_excellence
    security              = var.pillars.security
    reliability           = var.pillars.reliability
    performance_efficiency = var.pillars.performance_efficiency
    cost_optimization     = var.pillars.cost_optimization
    sustainability        = var.pillars.sustainability
  }

  # Security configurations with secure-by-default values
  security_config = {
    # KMS
    kms_key_deletion_window = 30
    enable_kms_key_rotation = true

    # Secrets Manager
    secret_recovery_window_days = 30

    # CloudTrail
    cloudtrail_enable_logging           = true
    cloudtrail_include_global_events    = true
    cloudtrail_is_multi_region_trail    = true
    cloudtrail_enable_log_file_validation = true

    # GuardDuty
    guardduty_enable_s3_protection       = true
    guardduty_enable_kubernetes_protection = true
    guardduty_enable_malware_protection  = true

    # Config
    config_delivery_frequency = "TwentyFour_Hours"

    # VPC Flow Logs
    vpc_flow_logs_traffic_type = "ALL"
    vpc_flow_logs_retention    = 14

    # WAF
    waf_default_action = "BLOCK"
  }

  # Monitoring configurations
  monitoring_config = {
    # CloudWatch
    log_retention_days = {
      production = 90
      staging   = 30
      test      = 7
      dev       = 3
    }[var.global_settings.environment]

    # Metrics
    detailed_monitoring_enabled = var.global_settings.environment == "production"

    # Alarms
    alarm_actions_enabled = true
  }

  # Performance configurations
  performance_config = {
    # EC2
    enable_enhanced_monitoring = var.global_settings.environment == "production"

    # S3
    s3_transfer_acceleration = var.performance_efficiency.enable_s3_transfer_acceleration

    # CloudFront
    cloudfront_price_class = var.global_settings.environment == "production" ? "PriceClass_All" : "PriceClass_100"
  }

  # Cost optimization configurations
  cost_config = {
    # Budgets
    budget_limit_amount = {
      production = 10000
      staging   = 5000
      test      = 1000
      dev       = 500
    }[var.global_settings.environment]

    # Instance types for cost optimization
    recommended_instance_types = {
      web_server    = ["t3.micro", "t3.small", "t3.medium"]
      app_server    = ["t3.medium", "t3.large", "m5.large"]
      database      = ["t3.micro", "t3.small", "r5.large"]
      cache         = ["t3.micro", "t3.small", "r5.large"]
    }
  }

  # Sustainability configurations
  sustainability_config = {
    # Prefer regions with renewable energy
    renewable_energy_regions = [
      "us-west-2", # Oregon - wind power
      "eu-north-1", # Stockholm - hydro power
      "ca-central-1", # Canada - hydro power
    ]

    # Graviton processor preference for sustainability
    prefer_graviton = var.sustainability.enable_graviton

    # Resource lifecycle policies
    enable_lifecycle_policies = var.sustainability.enable_resource_lifecycle
  }

  # Combined objects for cross-pillar resource sharing
  combined_objects = {
    vpc_id     = try(module.networking[0].vpc_id, null)
    subnet_ids = try(module.networking[0].subnet_ids, {})

    # Security objects
    kms_keys        = try(module.security[0].kms_keys, {})
    security_groups = try(module.security[0].security_groups, {})

    # Monitoring objects
    log_groups     = try(module.operational_excellence[0].log_groups, {})
    sns_topics     = try(module.operational_excellence[0].sns_topics, {})

    # Load balancers
    load_balancers = try(module.reliability[0].load_balancers, {})

    # S3 buckets
    s3_buckets = try(module.performance_efficiency[0].s3_buckets, {})
  }

  # Environment-specific configurations
  environment_config = {
    production = {
      multi_az                = true
      backup_retention_days   = 30
      monitoring_level       = "detailed"
      enable_deletion_protection = true
      instance_types         = ["m5.large", "m5.xlarge"]
    }
    staging = {
      multi_az                = true
      backup_retention_days   = 7
      monitoring_level       = "basic"
      enable_deletion_protection = false
      instance_types         = ["t3.medium", "t3.large"]
    }
    test = {
      multi_az                = false
      backup_retention_days   = 3
      monitoring_level       = "basic"
      enable_deletion_protection = false
      instance_types         = ["t3.small", "t3.medium"]
    }
    dev = {
      multi_az                = false
      backup_retention_days   = 1
      monitoring_level       = "basic"
      enable_deletion_protection = false
      instance_types         = ["t3.micro", "t3.small"]
    }
  }

  current_environment_config = local.environment_config[var.global_settings.environment]
}

# Random string for unique naming
resource "random_string" "prefix" {
  count = var.global_settings.passthrough ? 0 : 1

  length  = var.global_settings.random_length
  special = false
  upper   = false
  numeric = true
}