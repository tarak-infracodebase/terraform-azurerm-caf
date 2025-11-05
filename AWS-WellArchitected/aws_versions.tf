terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [
        aws.primary,
        aws.secondary,
        aws.logging,
        aws.security,
        aws.management
      ]
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.70.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }

  # Backend configuration for state management
  # Uncomment and configure based on your requirements
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "aws-well-architected/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

# Data sources for current AWS context
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_partition" "current" {}

# Provider configuration with assume role support for cross-account deployments
provider "aws" {
  alias = "primary"

  # Security best practices
  skip_region_validation      = false
  skip_credentials_validation = false
  skip_metadata_api_check     = false

  default_tags {
    tags = local.common_tags
  }
}

# Secondary region provider for multi-region deployments
provider "aws" {
  alias = "secondary"

  default_tags {
    tags = local.common_tags
  }
}

# Dedicated provider for logging account (if using AWS Control Tower)
provider "aws" {
  alias = "logging"

  # Uncomment for cross-account logging setup
  # assume_role {
  #   role_arn = "arn:aws:iam::LOGGING-ACCOUNT-ID:role/OrganizationAccountAccessRole"
  # }

  default_tags {
    tags = local.common_tags
  }
}

# Dedicated provider for security account (if using AWS Control Tower)
provider "aws" {
  alias = "security"

  # Uncomment for cross-account security setup
  # assume_role {
  #   role_arn = "arn:aws:iam::SECURITY-ACCOUNT-ID:role/OrganizationAccountAccessRole"
  # }

  default_tags {
    tags = local.common_tags
  }
}

# Dedicated provider for management account (if using AWS Control Tower)
provider "aws" {
  alias = "management"

  # Uncomment for cross-account management setup
  # assume_role {
  #   role_arn = "arn:aws:iam::MANAGEMENT-ACCOUNT-ID:role/OrganizationAccountAccessRole"
  # }

  default_tags {
    tags = local.common_tags
  }
}