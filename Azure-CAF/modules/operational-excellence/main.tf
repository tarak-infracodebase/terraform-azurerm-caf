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

# CloudTrail S3 bucket
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

# S3 bucket public access block
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

# CloudTrail bucket policy
resource "aws_s3_bucket_policy" "cloudtrail" {
  count = var.enable_cloudtrail ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail[0].bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail[0].arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.name_prefix}-cloudtrail"
          }
        }
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail[0].arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
            "AWS:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.name_prefix}-cloudtrail"
          }
        }
      }
    ]
  })
}

# CloudWatch log group for CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail" {
  count = var.enable_cloudtrail && var.enable_cloudwatch ? 1 : 0

  name              = "/aws/cloudtrail/${var.name_prefix}"
  retention_in_days = var.monitoring_config.log_retention_days
  kms_key_id        = var.kms_key_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-cloudtrail-logs"
  })
}

# IAM role for CloudTrail CloudWatch integration
resource "aws_iam_role" "cloudtrail_logs" {
  count = var.enable_cloudtrail && var.enable_cloudwatch ? 1 : 0

  name = "${var.name_prefix}-cloudtrail-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for CloudTrail CloudWatch integration
resource "aws_iam_role_policy" "cloudtrail_logs" {
  count = var.enable_cloudtrail && var.enable_cloudwatch ? 1 : 0

  name = "${var.name_prefix}-cloudtrail-logs-policy"
  role = aws_iam_role.cloudtrail_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
      }
    ]
  })
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

resource "aws_config_delivery_channel" "main" {
  count = var.enable_config ? 1 : 0

  name           = "${var.name_prefix}-config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config[0].bucket
  s3_key_prefix  = "config"

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}

# Config S3 bucket
resource "aws_s3_bucket" "config" {
  count = var.enable_config ? 1 : 0

  bucket        = "${var.name_prefix}-config-${random_string.config_bucket_suffix[0].result}"
  force_destroy = false

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-config-bucket"
  })
}

resource "random_string" "config_bucket_suffix" {
  count = var.enable_config ? 1 : 0

  length  = 8
  special = false
  upper   = false
}

# Config IAM role
resource "aws_iam_role" "config" {
  count = var.enable_config ? 1 : 0

  name = "${var.name_prefix}-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config" {
  count = var.enable_config ? 1 : 0

  role       = aws_iam_role.config[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/ConfigRole"
}

# Systems Manager for operational tasks
resource "aws_ssm_association" "inventory" {
  count = var.enable_systems_manager ? 1 : 0

  name = "AWS-GatherSoftwareInventory"

  targets {
    key    = "InstanceIds"
    values = ["*"]
  }

  schedule_expression = "rate(1 day)"
  compliance_severity = "MEDIUM"

  tags = var.tags
}

# EventBridge for event-driven automation
resource "aws_cloudwatch_event_rule" "operational_events" {
  count = var.enable_eventbridge ? 1 : 0

  name        = "${var.name_prefix}-operational-events"
  description = "Capture operational events for automated response"

  event_pattern = jsonencode({
    source        = ["aws.ec2", "aws.rds", "aws.lambda"]
    "detail-type" = ["EC2 Instance State-change Notification", "RDS DB Instance Event", "Lambda Function Invocation Result"]
  })

  tags = var.tags
}

# SNS topic for operational notifications
resource "aws_sns_topic" "operations" {
  name              = "${var.name_prefix}-operations"
  kms_master_key_id = var.kms_key_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-operations-topic"
  })
}

resource "aws_sns_topic_subscription" "operations_email" {
  count = var.operations_email != null ? 1 : 0

  topic_arn = aws_sns_topic.operations.arn
  protocol  = "email"
  endpoint  = var.operations_email
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}