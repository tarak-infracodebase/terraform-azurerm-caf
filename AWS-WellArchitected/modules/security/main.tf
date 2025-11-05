# Security Pillar
# Focus: Protect information, systems, and assets while delivering business value

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# KMS Key Management Service for encryption
resource "aws_kms_key" "main" {
  count = var.enable_kms ? 1 : 0

  description             = "${var.name_prefix} KMS key for encryption"
  deletion_window_in_days = var.security_config.kms_key_deletion_window
  enable_key_rotation     = var.security_config.enable_kms_key_rotation
  multi_region           = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-kms-key"
  })
}

resource "aws_kms_alias" "main" {
  count = var.enable_kms ? 1 : 0

  name          = "alias/${var.name_prefix}-main"
  target_key_id = aws_kms_key.main[0].key_id
}

# AWS Secrets Manager for secure credential storage
resource "aws_secretsmanager_secret" "database" {
  count = var.enable_secrets_manager ? 1 : 0

  name                    = "${var.name_prefix}-database-credentials"
  description             = "Database credentials for ${var.name_prefix}"
  kms_key_id             = var.enable_kms ? aws_kms_key.main[0].arn : null
  recovery_window_in_days = var.security_config.secret_recovery_window_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-database-secret"
  })
}

# Generate secure random password for database
resource "random_password" "database" {
  count = var.enable_secrets_manager ? 1 : 0

  length  = 32
  special = true
  upper   = true
  numeric = true
  lower   = true

  # Avoid characters that might cause issues
  override_special = "!@#$%^&*()-_=+{}[]|:;\"'<>,.?/"
}

# Store the generated password in Secrets Manager
resource "aws_secretsmanager_secret_version" "database" {
  count = var.enable_secrets_manager ? 1 : 0

  secret_id = aws_secretsmanager_secret.database[0].id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.database[0].result
  })
}

# GuardDuty for threat detection
resource "aws_guardduty_detector" "main" {
  count = var.enable_guardduty ? 1 : 0

  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  datasources {
    s3_logs {
      enable = var.security_config.guardduty_enable_s3_protection
    }
    kubernetes {
      audit_logs {
        enable = var.security_config.guardduty_enable_kubernetes_protection
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.security_config.guardduty_enable_malware_protection
        }
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-guardduty"
  })
}

# Security Hub for centralized security findings
resource "aws_securityhub_account" "main" {
  count = var.enable_security_hub ? 1 : 0

  enable_default_standards = true
  control_finding_generator = "SECURITY_CONTROL"
  auto_enable_controls     = true
}

# VPC Security Groups with secure defaults
resource "aws_security_group" "web" {
  name_prefix = "${var.name_prefix}-web-"
  description = "Security group for web servers"
  vpc_id      = var.vpc_id

  # HTTPS only inbound
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP redirect (should redirect to HTTPS)
  ingress {
    description = "HTTP redirect"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Restricted outbound - only HTTPS and DNS
  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "DNS outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-web-sg"
  })
}

resource "aws_security_group" "app" {
  name_prefix = "${var.name_prefix}-app-"
  description = "Security group for application servers"
  vpc_id      = var.vpc_id

  # Only allow traffic from web tier
  ingress {
    description     = "App port from web tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # Outbound to database and external APIs
  egress {
    description     = "Database access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.database.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-sg"
  })
}

resource "aws_security_group" "database" {
  name_prefix = "${var.name_prefix}-db-"
  description = "Security group for database servers"
  vpc_id      = var.vpc_id

  # Only allow traffic from app tier
  ingress {
    description     = "MySQL from app tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  # No outbound internet access for databases

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-sg"
  })
}

# IAM Password Policy - SECURITY: Enforce strong passwords
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers               = true
  require_uppercase_characters   = true
  require_symbols               = true
  allow_users_to_change_password = true
  max_password_age              = 90
  password_reuse_prevention     = 12
  hard_expiry                   = false
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}