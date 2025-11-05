# AWS Well-Architected Framework - Main Outputs

# Networking Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking[0].vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.networking[0].vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking[0].public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.networking[0].private_subnet_ids
}

output "database_subnet_ids" {
  description = "IDs of the database subnets"
  value       = module.networking[0].database_subnet_ids
}

output "db_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = module.networking[0].db_subnet_group_name
}

# Security Outputs
output "kms_key_arn" {
  description = "ARN of the KMS key"
  value       = local.enabled_pillars.security ? module.security[0].kms_keys.main.arn : null
  sensitive   = true
}

output "kms_key_id" {
  description = "ID of the KMS key"
  value       = local.enabled_pillars.security ? module.security[0].kms_keys.main.id : null
  sensitive   = true
}

output "security_groups" {
  description = "Security group information"
  value = local.enabled_pillars.security ? {
    web = {
      id   = module.security[0].security_groups.web.id
      name = module.security[0].security_groups.web.name
    }
    app = {
      id   = module.security[0].security_groups.app.id
      name = module.security[0].security_groups.app.name
    }
    database = {
      id   = module.security[0].security_groups.database.id
      name = module.security[0].security_groups.database.name
    }
  } : null
}

output "secrets_manager_arns" {
  description = "ARNs of Secrets Manager secrets"
  value       = local.enabled_pillars.security ? module.security[0].secrets : null
  sensitive   = true
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = local.enabled_pillars.security ? module.security[0].waf.web_acl_arn : null
}

# Operational Excellence Outputs
output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].cloudtrail.arn : null
}

output "cloudtrail_s3_bucket" {
  description = "S3 bucket for CloudTrail logs"
  value       = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].cloudtrail.bucket : null
}

output "sns_topic_operations_arn" {
  description = "ARN of the operations SNS topic"
  value       = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].sns_topics.operations.arn : null
}

output "config_recorder_name" {
  description = "Name of the Config recorder"
  value       = local.enabled_pillars.operational_excellence ? module.operational_excellence[0].config.recorder_name : null
}

# Reliability Outputs
output "load_balancer_dns" {
  description = "DNS name of the application load balancer"
  value       = local.enabled_pillars.reliability ? try(module.reliability[0].load_balancers.main.dns_name, null) : null
}

output "load_balancer_arn" {
  description = "ARN of the application load balancer"
  value       = local.enabled_pillars.reliability ? try(module.reliability[0].load_balancers.main.arn, null) : null
}

output "auto_scaling_groups" {
  description = "Auto Scaling Group information"
  value       = local.enabled_pillars.reliability ? try(module.reliability[0].auto_scaling_groups, null) : null
}

# Performance Efficiency Outputs
output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = local.enabled_pillars.performance_efficiency ? try(module.performance_efficiency[0].cloudfront.domain_name, null) : null
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = local.enabled_pillars.performance_efficiency ? try(module.performance_efficiency[0].cloudfront.id, null) : null
}

output "s3_bucket_arns" {
  description = "ARNs of S3 buckets"
  value       = local.enabled_pillars.performance_efficiency ? try(module.performance_efficiency[0].s3_buckets, null) : null
}

# Cost Optimization Outputs
output "budget_names" {
  description = "Names of created budgets"
  value       = local.enabled_pillars.cost_optimization ? try(module.cost_optimization[0].budgets, null) : null
}

output "cost_anomaly_detector_arn" {
  description = "ARN of the cost anomaly detector"
  value       = local.enabled_pillars.cost_optimization ? try(module.cost_optimization[0].cost_anomaly_detector.arn, null) : null
}

# Compute Resources Outputs
output "ec2_instance_ids" {
  description = "IDs of EC2 instances"
  value       = length(var.compute.ec2_instances) > 0 ? try(module.compute_resources[0].instance_ids, null) : null
}

output "lambda_function_arns" {
  description = "ARNs of Lambda functions"
  value       = length(var.compute.lambda_functions) > 0 ? try(module.compute_resources[0].lambda_arns, null) : null
}

# Database Outputs
output "rds_endpoint" {
  description = "RDS instance endpoints"
  value       = length(var.databases.rds_instances) > 0 ? try(module.database_resources[0].rds_endpoints, null) : null
  sensitive   = true
}

output "dynamodb_table_names" {
  description = "Names of DynamoDB tables"
  value       = length(var.databases.dynamodb_tables) > 0 ? try(module.database_resources[0].dynamodb_table_names, null) : null
}

output "dynamodb_table_arns" {
  description = "ARNs of DynamoDB tables"
  value       = length(var.databases.dynamodb_tables) > 0 ? try(module.database_resources[0].dynamodb_table_arns, null) : null
}

# Regional Information
output "deployment_region" {
  description = "AWS region where resources are deployed"
  value       = data.aws_region.current.name
}

output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

# Well-Architected Compliance
output "enabled_pillars" {
  description = "Well-Architected pillars that are enabled"
  value       = local.enabled_pillars
}

output "compliance_status" {
  description = "Well-Architected compliance status"
  value = {
    operational_excellence = local.enabled_pillars.operational_excellence
    security              = local.enabled_pillars.security
    reliability           = local.enabled_pillars.reliability
    performance_efficiency = local.enabled_pillars.performance_efficiency
    cost_optimization     = local.enabled_pillars.cost_optimization
    sustainability        = local.enabled_pillars.sustainability
  }
}

# Resource Summary
output "resource_summary" {
  description = "Summary of deployed resources"
  value = {
    vpc_created                = true
    subnets_created           = length(local.availability_zones) * 3  # public, private, database
    security_groups_created   = local.enabled_pillars.security ? 3 : 0
    kms_key_created          = local.enabled_pillars.security
    cloudtrail_enabled       = local.enabled_pillars.operational_excellence
    guardduty_enabled        = local.enabled_pillars.security
    config_enabled           = local.enabled_pillars.operational_excellence
    waf_enabled              = local.enabled_pillars.security
  }
}

# Tags Applied
output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}