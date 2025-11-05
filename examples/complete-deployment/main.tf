# Complete AWS Well-Architected Framework Deployment Example
# This example demonstrates how to deploy a comprehensive, enterprise-ready infrastructure

# Configure the AWS Provider
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend for remote state management
  backend "s3" {
    bucket         = "your-terraform-state-bucket"  # Replace with your bucket
    key            = "aws-well-architected/production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

# Configure default provider
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment     = "production"
      Project        = "aws-well-architected-example"
      ManagedBy      = "Terraform"
      Owner          = "platform-team"
      CostCenter     = "engineering"
    }
  }
}

# Deploy the complete AWS Well-Architected Framework
module "aws_well_architected" {
  source = "../../"  # Path to the main module

  # Global Configuration
  global_settings = {
    organization_name = "example-corp"
    environment      = "production"
    project_name     = "ecommerce-platform"
    cost_center      = "engineering"
    owner           = "platform-team"

    # Multi-region setup
    primary_region   = "us-east-1"
    secondary_region = "us-west-2"

    tags = {
      BusinessUnit = "ecommerce"
      Compliance   = "pci-dss"
      DataClass    = "confidential"
    }
  }

  # Enable all Well-Architected pillars
  pillars = {
    operational_excellence = true
    security              = true
    reliability           = true
    performance_efficiency = true
    cost_optimization     = true
    sustainability        = true
  }

  # Account Configuration for multi-account setup
  account_config = {
    enable_cross_account = false  # Set to true for Control Tower setup
    # primary_account_id   = "123456789012"
    # logging_account_id   = "123456789013"
    # security_account_id  = "123456789014"
  }

  # Networking Configuration
  networking = {
    vpc_cidr             = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    enable_nat_gateway   = true
    enable_vpn_gateway   = false
    enable_flow_logs     = true

    # Use 3 availability zones for high availability
    availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

    # Advanced networking features
    enable_transit_gateway = false
    enable_direct_connect = false
  }

  # Operational Excellence Configuration
  operational_excellence = {
    enable_cloudwatch     = true
    enable_xray          = true
    enable_cloudtrail    = true
    enable_systems_manager = true
    enable_config        = true
    enable_application_insights = true
    enable_eventbridge   = true
    enable_codepipeline  = false  # Enable if using CI/CD
    enable_codebuild     = false
  }

  # Security Configuration
  security = {
    enable_organizations = false  # Enable for multi-account
    enable_sso          = false   # Enable for SSO integration

    # Data Protection
    enable_kms            = true
    enable_secrets_manager = true

    # Threat Detection
    enable_guardduty      = true
    enable_security_hub   = true
    enable_inspector      = true
    enable_macie         = false  # Enable for data discovery

    # Infrastructure Protection
    enable_waf           = true
    enable_shield        = false  # Enable Shield Advanced if needed

    # Compliance
    enable_config        = true
    enable_cloudtrail    = true
    enable_vpc_flow_logs = true
  }

  # Reliability Configuration
  reliability = {
    enable_multi_az                   = true
    enable_auto_scaling              = true
    enable_backup                    = true
    enable_disaster_recovery         = false  # Enable for DR requirements
    enable_application_load_balancer = true
    enable_network_load_balancer    = false
    enable_rds_multi_az             = true
    enable_aurora                   = false   # Enable for serverless DB
    enable_cloudwatch_alarms        = true
    enable_sns_notifications        = true
  }

  # Performance Efficiency Configuration
  performance_efficiency = {
    enable_ec2_optimization = true
    enable_lambda         = true
    enable_fargate        = false  # Enable for containerized workloads
    enable_s3_optimization = true
    enable_efs            = false
    enable_database_optimization = true
    enable_elasticache    = false  # Enable for caching requirements
    enable_cloudfront     = true
    enable_route53       = true
    enable_s3_transfer_acceleration = false
  }

  # Cost Optimization Configuration
  cost_optimization = {
    enable_cost_explorer     = true
    enable_budgets          = true
    enable_reserved_instances = false  # Enable for predictable workloads
    enable_savings_plans    = false
    enable_spot_instances   = false   # Enable for fault-tolerant workloads
    enable_auto_scaling     = true
    enable_trusted_advisor  = true
    enable_compute_optimizer = true
    enable_cost_allocation_tags = true
  }

  # Sustainability Configuration
  sustainability = {
    enable_carbon_footprint_tracking = true
    enable_sustainability_insights  = true
    enable_right_sizing             = true
    enable_graviton                 = false  # Enable for ARM-based instances
    prefer_renewable_energy_regions = true
    enable_resource_lifecycle       = true
  }

  # Compute Resources
  compute = {
    ec2_instances = {
      web_servers = {
        instance_type     = "t3.medium"
        min_size         = 2
        max_size         = 10
        desired_capacity = 3

        user_data = {
          install_cloudwatch_agent = true
          install_ssm_agent        = true
        }

        security_groups = ["web"]
        subnet_type     = "private"  # Place behind load balancer

        tags = {
          Tier = "web"
          Role = "frontend"
        }
      }

      app_servers = {
        instance_type     = "t3.large"
        min_size         = 2
        max_size         = 8
        desired_capacity = 2

        security_groups = ["app"]
        subnet_type     = "private"

        tags = {
          Tier = "app"
          Role = "backend"
        }
      }
    }

    lambda_functions = {
      api_processor = {
        runtime     = "python3.9"
        handler     = "lambda_function.lambda_handler"
        timeout     = 30
        memory_size = 256

        environment_variables = {
          ENVIRONMENT = "production"
          LOG_LEVEL   = "INFO"
        }
      }
    }
  }

  # Database Resources
  databases = {
    rds_instances = {
      primary_db = {
        engine           = "mysql"
        engine_version   = "8.0"
        instance_class   = "db.t3.medium"
        allocated_storage = 100

        # Well-Architected security defaults
        storage_encrypted    = true
        multi_az            = true
        backup_retention_period = 30
        backup_window       = "03:00-04:00"
        maintenance_window  = "sun:04:00-sun:05:00"

        monitoring_interval = 60

        tags = {
          Tier = "database"
          Role = "primary"
        }
      }
    }

    dynamodb_tables = {
      user_sessions = {
        name           = "user-sessions"
        billing_mode   = "PAY_PER_REQUEST"
        hash_key       = "session_id"

        attributes = [
          {
            name = "session_id"
            type = "S"
          }
        ]

        ttl = {
          attribute_name = "expires_at"
          enabled        = true
        }

        point_in_time_recovery_enabled = true

        tags = {
          Tier = "cache"
          Role = "sessions"
        }
      }
    }
  }

  # Storage Resources
  storage = {
    s3_buckets = {
      application_assets = {
        bucket_name = "ecommerce-assets"

        versioning = {
          enabled = true
        }

        lifecycle_configuration = {
          rules = [
            {
              id     = "archive_old_versions"
              status = "Enabled"

              noncurrent_version_transitions = [
                {
                  days          = 30
                  storage_class = "STANDARD_INFREQUENT_ACCESS"
                },
                {
                  days          = 90
                  storage_class = "GLACIER"
                },
                {
                  days          = 365
                  storage_class = "DEEP_ARCHIVE"
                }
              ]
            }
          ]
        }

        cors_configuration = {
          cors_rules = [
            {
              allowed_headers = ["*"]
              allowed_methods = ["GET", "HEAD"]
              allowed_origins = ["https://your-domain.com"]
              max_age_seconds = 3000
            }
          ]
        }
      }

      application_logs = {
        bucket_name = "ecommerce-logs"

        lifecycle_configuration = {
          rules = [
            {
              id     = "delete_old_logs"
              status = "Enabled"

              expiration = {
                days = 90  # Comply with retention policies
              }
            }
          ]
        }
      }
    }
  }

  # Monitoring Configuration
  monitoring = {
    cloudwatch_dashboards = {
      application_overview = {
        dashboard_name = "Application-Overview"

        widgets = [
          {
            type = "metric"
            properties = {
              metrics = [
                ["AWS/ApplicationELB", "RequestCount"],
                ["AWS/ApplicationELB", "TargetResponseTime"],
                ["AWS/RDS", "DatabaseConnections"],
                ["AWS/Lambda", "Invocations"]
              ]
            }
          }
        ]
      }
    }

    cloudwatch_alarms = {
      high_response_time = {
        alarm_name          = "high-response-time"
        comparison_operator = "GreaterThanThreshold"
        evaluation_periods  = "2"
        metric_name         = "TargetResponseTime"
        namespace           = "AWS/ApplicationELB"
        period              = "60"
        statistic           = "Average"
        threshold           = "1.0"
        alarm_description   = "This metric monitors ALB response time"
      }
    }
  }
}

# Outputs for other teams/modules to consume
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.aws_well_architected.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.aws_well_architected.private_subnet_ids
}

output "security_groups" {
  description = "Security group IDs for different tiers"
  value       = module.aws_well_architected.security_groups
}

output "kms_key_arn" {
  description = "ARN of the KMS key for encryption"
  value       = module.aws_well_architected.kms_key_arn
  sensitive   = true
}

output "load_balancer_dns" {
  description = "DNS name of the application load balancer"
  value       = module.aws_well_architected.load_balancer_dns
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = module.aws_well_architected.cloudfront_domain
}