# CloudWatch module for comprehensive monitoring and observability

# Application-specific log groups
resource "aws_cloudwatch_log_group" "application" {
  for_each = var.log_groups

  name              = "/aws/${each.key}/${var.name_prefix}"
  retention_in_days = var.log_retention
  kms_key_id        = var.kms_key_id

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${each.key}-logs"
    LogGroupType = each.value.type
  })
}

# CloudWatch Dashboard for operational visibility
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.name_prefix}-operational-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization"],
            ["AWS/ApplicationELB", "RequestCount"],
            ["AWS/Lambda", "Invocations"],
            ["AWS/RDS", "CPUUtilization"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Key Performance Metrics"
          period  = 300
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          query   = "SOURCE '/aws/lambda/${var.name_prefix}' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          region  = var.region
          title   = "Recent Application Logs"
        }
      }
    ]
  })
}

# CloudWatch Alarms for critical metrics
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  for_each = var.enable_default_alarms ? toset(["ec2", "rds"]) : toset([])

  alarm_name          = "${var.name_prefix}-high-cpu-${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = each.key == "ec2" ? "AWS/EC2" : "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ${each.key} cpu utilization"
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-high-cpu-${each.key}"
  })
}

# Application Insights for enhanced monitoring
resource "aws_applicationinsights_application" "main" {
  count = var.enable_insights ? 1 : 0

  resource_group_name                = aws_resourcegroups_group.main[0].name
  auto_config_enabled               = true
  cwe_monitor_enabled              = true
  auto_create                      = false

  log_pattern {
    pattern_name = "${var.name_prefix}-error-pattern"
    pattern      = "[ERROR]"
    rank         = 1
  }

  tags = var.tags
}

# Resource group for Application Insights
resource "aws_resourcegroups_group" "main" {
  count = var.enable_insights ? 1 : 0

  name = "${var.name_prefix}-resources"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = [
        "AWS::EC2::Instance",
        "AWS::Lambda::Function",
        "AWS::RDS::DBInstance",
        "AWS::ApplicationELB::LoadBalancer"
      ]
      TagFilters = [
        {
          Key    = "Environment"
          Values = [var.environment]
        }
      ]
    })
  }

  tags = var.tags
}

# CloudWatch Composite Alarms for intelligent alerting
resource "aws_cloudwatch_composite_alarm" "application_health" {
  count = var.enable_composite_alarms ? 1 : 0

  alarm_name        = "${var.name_prefix}-application-health"
  alarm_description = "Composite alarm monitoring overall application health"

  alarm_rule = format(
    "ALARM(%s) OR ALARM(%s)",
    aws_cloudwatch_metric_alarm.high_cpu["ec2"].alarm_name,
    aws_cloudwatch_metric_alarm.high_error_rate[0].alarm_name
  )

  actions_enabled = true
  alarm_actions   = [var.sns_topic_arn]
  ok_actions      = [var.sns_topic_arn]

  tags = var.tags
}

# Error rate alarm
resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
  count = var.enable_default_alarms ? 1 : 0

  alarm_name          = "${var.name_prefix}-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "4XXError"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors application error rate"
  alarm_actions       = [var.sns_topic_arn]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-high-error-rate"
  })
}

# CloudWatch Synthetics for proactive monitoring
resource "aws_synthetics_canary" "health_check" {
  count = var.enable_synthetics ? 1 : 0

  name                 = "${var.name_prefix}-health-check"
  artifact_s3_location = "s3://${var.synthetics_bucket}/canary-artifacts/"
  execution_role_arn   = var.synthetics_role_arn
  handler              = "healthCheck.handler"
  zip_file             = var.synthetics_zip_file
  runtime_version      = "syn-nodejs-puppeteer-6.1"

  schedule {
    expression                = "rate(5 minutes)"
    duration_in_seconds      = 0
  }

  run_config {
    timeout_in_seconds    = 60
    memory_in_mb         = 960
    active_tracing       = true
  }

  tags = var.tags
}

# CloudWatch Logs Insights saved queries
resource "aws_cloudwatch_query_definition" "error_analysis" {
  name = "${var.name_prefix}-error-analysis"

  log_group_names = [
    for lg in aws_cloudwatch_log_group.application : lg.name
  ]

  query_string = <<EOF
fields @timestamp, @message
| filter @message like /ERROR/
| stats count() by bin(5m)
| sort @timestamp desc
EOF
}