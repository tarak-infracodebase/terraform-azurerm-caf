# AWS Well-Architected Framework - Main Configuration

# Foundation: Networking Infrastructure (Required for all pillars)
module "networking" {
  count = 1

  source = "./modules/shared/networking"

  # Configuration
  name_prefix        = local.name_prefix
  vpc_cidr          = var.networking.vpc_cidr
  availability_zones = local.availability_zones
  subnet_cidrs      = local.subnet_cidrs

  # Well-Architected settings
  enable_dns_hostnames = var.networking.enable_dns_hostnames
  enable_dns_support   = var.networking.enable_dns_support
  enable_nat_gateway   = var.networking.enable_nat_gateway
  enable_vpn_gateway   = var.networking.enable_vpn_gateway
  enable_flow_logs     = var.networking.enable_flow_logs

  # Advanced networking
  enable_transit_gateway = var.networking.enable_transit_gateway

  # Cross-pillar integration
  enable_security_groups = local.enabled_pillars.security
  enable_monitoring     = local.enabled_pillars.operational_excellence

  # Tags
  tags = local.common_tags
}

# Pillar 1: Operational Excellence
module "operational_excellence" {
  count = local.enabled_pillars.operational_excellence ? 1 : 0

  source = "./modules/operational-excellence"

  # Configuration
  name_prefix     = local.name_prefix
  account_config  = local.account_config
  vpc_id         = module.networking[0].vpc_id
  subnet_ids     = module.networking[0].subnet_ids

  # Operational Excellence settings
  enable_cloudwatch     = var.operational_excellence.enable_cloudwatch
  enable_xray          = var.operational_excellence.enable_xray
  enable_cloudtrail    = var.operational_excellence.enable_cloudtrail
  enable_systems_manager = var.operational_excellence.enable_systems_manager
  enable_config        = var.operational_excellence.enable_config
  enable_eventbridge   = var.operational_excellence.enable_eventbridge

  # Monitoring configuration
  monitoring_config = local.monitoring_config

  # Tags
  tags = local.common_tags

  depends_on = [module.networking]
}

# Pillar 2: Security
module "security" {
  count = local.enabled_pillars.security ? 1 : 0

  source = "./modules/security"

  # Configuration
  name_prefix     = local.name_prefix
  account_config  = local.account_config
  vpc_id         = module.networking[0].vpc_id
  subnet_ids     = module.networking[0].subnet_ids

  # Security settings
  enable_kms            = var.security.enable_kms
  enable_secrets_manager = var.security.enable_secrets_manager
  enable_guardduty      = var.security.enable_guardduty
  enable_security_hub   = var.security.enable_security_hub
  enable_inspector      = var.security.enable_inspector
  enable_waf           = var.security.enable_waf
  enable_config        = var.security.enable_config
  enable_cloudtrail    = var.security.enable_cloudtrail

  # Security configuration
  security_config = local.security_config

  # Cross-pillar integration
  cloudwatch_log_groups = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].log_groups : {}

  # Tags
  tags = local.common_tags

  depends_on = [module.networking, module.operational_excellence]
}

# Pillar 3: Reliability
module "reliability" {
  count = local.enabled_pillars.reliability ? 1 : 0

  source = "./modules/reliability"

  # Configuration
  name_prefix     = local.name_prefix
  account_config  = local.account_config
  vpc_id         = module.networking[0].vpc_id
  subnet_ids     = module.networking[0].subnet_ids

  # Reliability settings
  enable_multi_az               = var.reliability.enable_multi_az
  enable_auto_scaling          = var.reliability.enable_auto_scaling
  enable_backup               = var.reliability.enable_backup
  enable_application_load_balancer = var.reliability.enable_application_load_balancer
  enable_rds_multi_az         = var.reliability.enable_rds_multi_az
  enable_cloudwatch_alarms    = var.reliability.enable_cloudwatch_alarms

  # Environment configuration
  environment_config = local.current_environment_config

  # Cross-pillar integration
  kms_keys          = local.enabled_pillars.security ? module.security[0].kms_keys : {}
  cloudwatch_log_groups = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].log_groups : {}

  # Tags
  tags = local.common_tags

  depends_on = [module.networking, module.security, module.operational_excellence]
}

# Pillar 4: Performance Efficiency
module "performance_efficiency" {
  count = local.enabled_pillars.performance_efficiency ? 1 : 0

  source = "./modules/performance-efficiency"

  # Configuration
  name_prefix     = local.name_prefix
  account_config  = local.account_config
  vpc_id         = module.networking[0].vpc_id
  subnet_ids     = module.networking[0].subnet_ids

  # Performance settings
  enable_ec2_optimization = var.performance_efficiency.enable_ec2_optimization
  enable_lambda          = var.performance_efficiency.enable_lambda
  enable_s3_optimization = var.performance_efficiency.enable_s3_optimization
  enable_cloudfront      = var.performance_efficiency.enable_cloudfront
  enable_elasticache     = var.performance_efficiency.enable_elasticache

  # Performance configuration
  performance_config = local.performance_config

  # Cross-pillar integration
  kms_keys          = local.enabled_pillars.security ? module.security[0].kms_keys : {}
  cloudwatch_log_groups = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].log_groups : {}

  # Tags
  tags = local.common_tags

  depends_on = [module.networking, module.security, module.operational_excellence]
}

# Pillar 5: Cost Optimization
module "cost_optimization" {
  count = local.enabled_pillars.cost_optimization ? 1 : 0

  source = "./modules/cost-optimization"

  # Configuration
  name_prefix     = local.name_prefix
  account_config  = local.account_config

  # Cost optimization settings
  enable_cost_explorer    = var.cost_optimization.enable_cost_explorer
  enable_budgets         = var.cost_optimization.enable_budgets
  enable_trusted_advisor = var.cost_optimization.enable_trusted_advisor
  enable_compute_optimizer = var.cost_optimization.enable_compute_optimizer

  # Cost configuration
  cost_config = local.cost_config

  # Cross-pillar integration
  sns_topics = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].sns_topics : {}

  # Tags
  tags = local.common_tags

  depends_on = [module.operational_excellence]
}

# Pillar 6: Sustainability
module "sustainability" {
  count = local.enabled_pillars.sustainability ? 1 : 0

  source = "./modules/sustainability"

  # Configuration
  name_prefix     = local.name_prefix
  account_config  = local.account_config

  # Sustainability settings
  enable_carbon_footprint_tracking = var.sustainability.enable_carbon_footprint_tracking
  enable_right_sizing              = var.sustainability.enable_right_sizing
  prefer_renewable_energy_regions  = var.sustainability.prefer_renewable_energy_regions

  # Sustainability configuration
  sustainability_config = local.sustainability_config

  # Cross-pillar integration
  cloudwatch_log_groups = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].log_groups : {}

  # Tags
  tags = local.common_tags

  depends_on = [module.operational_excellence]
}

# Resource implementations based on configuration
module "compute_resources" {
  count = length(var.compute.ec2_instances) > 0 ? 1 : 0

  source = "./modules/shared/compute"

  # Configuration
  name_prefix    = local.name_prefix
  vpc_id        = module.networking[0].vpc_id
  subnet_ids    = module.networking[0].subnet_ids

  # Compute configuration
  ec2_instances       = var.compute.ec2_instances
  auto_scaling_groups = var.compute.auto_scaling_groups
  lambda_functions    = var.compute.lambda_functions

  # Cross-pillar integration
  security_groups    = local.enabled_pillars.security ? module.security[0].security_groups : {}
  kms_keys          = local.enabled_pillars.security ? module.security[0].kms_keys : {}
  load_balancers    = local.enabled_pillars.reliability ? module.reliability[0].load_balancers : {}

  # Environment-specific settings
  environment_config = local.current_environment_config

  # Tags
  tags = local.common_tags

  depends_on = [
    module.networking,
    module.security,
    module.reliability,
    module.operational_excellence
  ]
}

module "database_resources" {
  count = length(var.databases.rds_instances) > 0 || length(var.databases.aurora_clusters) > 0 || length(var.databases.dynamodb_tables) > 0 ? 1 : 0

  source = "./modules/shared/databases"

  # Configuration
  name_prefix    = local.name_prefix
  vpc_id        = module.networking[0].vpc_id
  subnet_ids    = module.networking[0].subnet_ids

  # Database configuration
  rds_instances     = var.databases.rds_instances
  aurora_clusters   = var.databases.aurora_clusters
  dynamodb_tables   = var.databases.dynamodb_tables
  elasticache_clusters = var.databases.elasticache_clusters

  # Cross-pillar integration
  security_groups = local.enabled_pillars.security ? module.security[0].security_groups : {}
  kms_keys       = local.enabled_pillars.security ? module.security[0].kms_keys : {}

  # Environment-specific settings
  environment_config = local.current_environment_config

  # Tags
  tags = local.common_tags

  depends_on = [
    module.networking,
    module.security,
    module.operational_excellence
  ]
}

module "storage_resources" {
  count = length(var.storage.s3_buckets) > 0 ? 1 : 0

  source = "./modules/shared/storage"

  # Configuration
  name_prefix = local.name_prefix

  # Storage configuration
  s3_buckets      = var.storage.s3_buckets
  efs_file_systems = var.storage.efs_file_systems

  # Cross-pillar integration
  kms_keys = local.enabled_pillars.security ? module.security[0].kms_keys : {}

  # Environment-specific settings
  environment_config = local.current_environment_config

  # Tags
  tags = local.common_tags

  depends_on = [module.security]
}