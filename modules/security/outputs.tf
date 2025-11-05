# Security Pillar Outputs

output "kms_keys" {
  description = "KMS keys for encryption"
  value = var.enable_kms ? {
    main = {
      id     = aws_kms_key.main[0].key_id
      arn    = aws_kms_key.main[0].arn
      alias  = aws_kms_alias.main[0].name
    }
  } : {}
  sensitive = true
}

output "secrets" {
  description = "Secrets Manager secrets"
  value = var.enable_secrets_manager ? {
    database = {
      arn  = aws_secretsmanager_secret.database[0].arn
      name = aws_secretsmanager_secret.database[0].name
    }
  } : {}
  sensitive = true
}

output "security_groups" {
  description = "Security groups for different tiers"
  value = {
    web = {
      id   = aws_security_group.web.id
      name = aws_security_group.web.name
    }
    app = {
      id   = aws_security_group.app.id
      name = aws_security_group.app.name
    }
    database = {
      id   = aws_security_group.database.id
      name = aws_security_group.database.name
    }
  }
}

output "guardduty" {
  description = "GuardDuty configuration"
  value = var.enable_guardduty ? {
    detector_id = aws_guardduty_detector.main[0].id
  } : null
}

output "security_hub" {
  description = "Security Hub configuration"
  value = var.enable_security_hub ? {
    account_id = aws_securityhub_account.main[0].id
  } : null
}

output "waf" {
  description = "WAF configuration"
  value = var.enable_waf ? {
    web_acl_id  = aws_wafv2_web_acl.main[0].id
    web_acl_arn = aws_wafv2_web_acl.main[0].arn
  } : null
}

output "vpc_flow_logs" {
  description = "VPC Flow Logs configuration"
  value = var.enable_vpc_flow_logs && var.vpc_id != null ? {
    log_group_name = aws_cloudwatch_log_group.vpc_flow_logs[0].name
    log_group_arn  = aws_cloudwatch_log_group.vpc_flow_logs[0].arn
  } : null
}

output "inspector" {
  description = "Inspector configuration"
  value = var.enable_inspector ? {
    account_ids    = aws_inspector2_enabler.main[0].account_ids
    resource_types = aws_inspector2_enabler.main[0].resource_types
  } : null
}