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
  }

  # Security Configuration
  security = {
    # Data Protection
    enable_kms            = true
    enable_secrets_manager = true

    # Threat Detection
    enable_guardduty      = true
    enable_security_hub   = true
    enable_inspector      = true

    # Infrastructure Protection
    enable_waf           = true
    enable_vpc_flow_logs = true
  }

  # Operational Excellence Configuration
  operational_excellence = {
    enable_cloudwatch     = true
    enable_xray          = true
    enable_cloudtrail    = true
    enable_systems_manager = true
    enable_config        = true
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