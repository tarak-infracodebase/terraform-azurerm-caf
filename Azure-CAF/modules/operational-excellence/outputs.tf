# Operational Excellence Pillar Outputs

output "cloudtrail" {
  description = "CloudTrail configuration"
  value = var.enable_cloudtrail ? {
    arn    = aws_cloudtrail.main[0].arn
    name   = aws_cloudtrail.main[0].name
    bucket = aws_s3_bucket.cloudtrail[0].bucket
  } : null
}

output "log_groups" {
  description = "CloudWatch log groups"
  value = var.enable_cloudwatch ? {
    cloudtrail = var.enable_cloudtrail ? aws_cloudwatch_log_group.cloudtrail[0].name : null
  } : {}
}

output "sns_topics" {
  description = "SNS topics for notifications"
  value = {
    operations = {
      arn  = aws_sns_topic.operations.arn
      name = aws_sns_topic.operations.name
    }
  }
}

output "config" {
  description = "AWS Config configuration"
  value = var.enable_config ? {
    recorder_name   = aws_config_configuration_recorder.main[0].name
    delivery_channel = aws_config_delivery_channel.main[0].name
    bucket         = aws_s3_bucket.config[0].bucket
  } : null
}

output "xray" {
  description = "X-Ray configuration"
  value = var.enable_xray ? {
    encryption_config = aws_xray_encryption_config.main[0].type
  } : null
}

output "eventbridge" {
  description = "EventBridge rules"
  value = var.enable_eventbridge ? {
    operational_events = {
      name = aws_cloudwatch_event_rule.operational_events[0].name
      arn  = aws_cloudwatch_event_rule.operational_events[0].arn
    }
  } : null
}