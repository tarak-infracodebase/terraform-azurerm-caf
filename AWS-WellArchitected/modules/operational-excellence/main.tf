# Operational Excellence Pillar
# Focus: Run and monitor systems to deliver business value and improve processes

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# CloudWatch for monitoring and observability
module "cloudwatch" {
  count = var.enable_cloudwatch ? 1 : 0

  source = "./cloudwatch"

  name_prefix       = var.name_prefix
  log_retention     = var.monitoring_config.log_retention_days
  enable_insights   = var.enable_application_insights

  tags = var.tags
}

# AWS X-Ray for distributed tracing
resource "aws_xray_encryption_config" "main" {
  count = var.enable_xray ? 1 : 0

  type   = "KMS"
  key_id = var.kms_key_id
}

# CloudTrail for API logging and compliance
resource "aws_cloudtrail" "main" {
  count = var.enable_cloudtrail ? 1 : 0

  name                          = "${var.name_prefix}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail[0].bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true

  # Encrypt CloudTrail logs
  kms_key_id = var.kms_key_id

  event_selector {
    read_write_type                 = "All"
    include_management_events       = true
    exclude_management_event_sources = []

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::*/*"]
    }

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda:*:*:function:*"]
    }
  }

  # Send CloudTrail logs to CloudWatch
  cloud_watch_logs_group_arn = var.enable_cloudwatch ? "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*" : null
  cloud_watch_logs_role_arn  = var.enable_cloudwatch ? aws_iam_role.cloudtrail_logs[0].arn : null

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-cloudtrail"
  })

  depends_on = [aws_s3_bucket_policy.cloudtrail]
}

# CloudTrail S3 bucket with secure defaults
resource "aws_s3_bucket" "cloudtrail" {
  count = var.enable_cloudtrail ? 1 : 0

  bucket        = "${var.name_prefix}-cloudtrail-${random_string.bucket_suffix[0].result}"
  force_destroy = false

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-cloudtrail-bucket"
  })
}

resource "random_string" "bucket_suffix" {
  count = var.enable_cloudtrail ? 1 : 0

  length  = 8
  special = false
  upper   = false
}

# S3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  count = var.enable_cloudtrail ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail[0].bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# S3 bucket public access block - SECURITY: Block all public access
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  count = var.enable_cloudtrail ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail[0].bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "cloudtrail" {
  count = var.enable_cloudtrail ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail[0].bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# AWS Config for configuration compliance
resource "aws_config_configuration_recorder" "main" {
  count = var.enable_config ? 1 : 0

  name     = "${var.name_prefix}-config-recorder"
  role_arn = aws_iam_role.config[0].arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  depends_on = [aws_config_delivery_channel.main]
}

# SNS topic for operational notifications
resource "aws_sns_topic" "operations" {
  name              = "${var.name_prefix}-operations"
  kms_master_key_id = var.kms_key_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-operations-topic"
  })
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}