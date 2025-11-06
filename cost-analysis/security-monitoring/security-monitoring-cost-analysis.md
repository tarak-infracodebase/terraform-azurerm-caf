# Security & Monitoring Services - Cost Analysis

## Overview
Security and monitoring services typically represent 10-20% of total Azure infrastructure costs. While these costs may seem secondary, they're essential for compliance, governance, and operational excellence.

---

## 🔐 Azure Key Vault

### Configuration Options (from `keyvault*.tf`)
- Standard and Premium (HSM-backed) tiers
- Secrets, keys, and certificates management
- Access policies and RBAC authorization
- Private endpoints and network restrictions
- Automated backup and recovery

### Key Vault Pricing

#### **Standard Tier**
```
Operations:
- Secret operations: $0.03 per 10,000 transactions
- Key operations: $0.03 per 10,000 transactions
- Certificate operations: $3 per certificate request

Storage: Minimal cost (negligible for most use cases)

Example Monthly Costs:
Small usage (10K ops): $3/month
Medium usage (100K ops): $30/month
High usage (1M ops): $300/month
```

#### **Premium Tier (HSM-backed)**
```
Operations:
- HSM key operations: $1.00 per 10,000 transactions
- All Standard tier operations included

Additional Features:
- Hardware Security Module (HSM) protection
- FIPS 140-2 Level 2 validated HSMs
- Import/export of HSM-protected keys

Example Monthly Costs:
Small usage: $10/month base
Medium usage: $100/month
High usage: $1,000+/month
```

### Key Vault Cost Examples

#### **Basic Application (Standard)**
```
Monthly Usage:
- 5,000 secret retrievals
- 1,000 key operations
- 2 certificate renewals

Cost Calculation:
- Secrets: (5,000/10,000) × $0.03 = $0.015
- Keys: (1,000/10,000) × $0.03 = $0.003
- Certificates: 2 × $3 = $6
Total: ~$6/month
```

#### **Enterprise Application (Premium)**
```
Monthly Usage:
- 100,000 HSM key operations
- 50,000 secret operations
- 10 certificate renewals

Cost Calculation:
- HSM keys: (100,000/10,000) × $1.00 = $10
- Secrets: (50,000/10,000) × $0.03 = $0.15
- Certificates: 10 × $3 = $30
Total: ~$40/month
```

---

## 📊 Log Analytics & Azure Monitor

### Configuration Options (from `monitoring.tf`, `log_analytics*.tf`)
- Multiple pricing tiers (Per GB, Commitment Tiers)
- Data retention policies (30-730 days)
- Workspace-based and resource-based logs
- Custom log ingestion and queries
- Alert rules and action groups

### Log Analytics Pricing

#### **Per GB Pricing**
```
Data Ingestion: $2.30/GB
Data Retention:
- First 31 days: Free
- Days 32-730: $0.10/GB/month

Example Monthly Costs:
1GB/day (30GB/month): $69 + retention
5GB/day (150GB/month): $345 + retention
20GB/day (600GB/month): $1,380 + retention
100GB/day (3TB/month): $6,900 + retention
```

#### **Commitment Tiers (Discounted)**
```
100GB/day: $1,956/month (15% discount)
200GB/day: $3,690/month (20% discount)
300GB/day: $5,317/month (23% discount)
400GB/day: $6,893/month (25% discount)
500GB/day: $8,468/month (26% discount)

Break-even: Consistent daily ingestion above tier level
```

### Data Sources & Typical Volumes

#### **Azure Activity Logs**
```
Volume: 10-50MB/day per subscription
Cost: ~$0.70-3.50/month per subscription
```

#### **VM Performance Counters**
```
Volume: 100MB-1GB/day per VM
Cost: ~$7-70/month per VM
```

#### **Application Insights**
```
Volume: 1-10GB/day for large applications
Cost: ~$70-700/month per application
```

#### **Security Logs (Microsoft Sentinel)**
```
Volume: 5-50GB/day for medium organizations
Cost: ~$350-3,500/month
```

### Log Analytics Cost Examples

#### **Small Organization**
```
Data Sources:
- 5 VMs performance counters: 2GB/day
- Activity logs: 50MB/day
- Application logs: 1GB/day
Total: ~3GB/day

Monthly Cost:
- Ingestion: 3 × 30 × $2.30 = $207
- Retention (90 days): Minimal additional
Total: ~$210/month
```

#### **Medium Organization**
```
Data Sources:
- 50 VMs: 20GB/day
- Multiple applications: 10GB/day
- Security logs: 5GB/day
- Network logs: 5GB/day
Total: ~40GB/day

Monthly Cost:
- Ingestion: 40 × 30 × $2.30 = $2,760
- Could use 100GB commitment: $1,956
- Savings: ~$800/month with commitment
```

---

## 🛡️ Microsoft Sentinel (SIEM)

### Configuration Options (from `sentinel_*.tf`)
- Built on Log Analytics workspace
- Security orchestration and response (SOAR)
- Machine learning analytics
- Threat intelligence integration
- Custom detection rules and playbooks

### Sentinel Pricing
```
Data Ingestion: $2.30/GB (same as Log Analytics)
Additional Sentinel Features: No extra charge

Typical Security Data Sources:
- Windows Security Events: 1-5GB/day per 100 users
- Azure AD Sign-ins: 100MB-1GB/day
- Office 365: 500MB-5GB/day
- Network Security Groups: 1-10GB/day
- Firewall logs: 2-20GB/day per firewall

Example: 500-user organization
Total security data: 20-50GB/day
Monthly cost: $1,380-3,450
```

### Sentinel Cost Optimization
- ✅ **Filter irrelevant data** at source (NSG flow logs, verbose application logs)
- ✅ Use **data transformation** to reduce volume
- ✅ Implement **log retention policies** (shorter for high-volume, low-value data)
- ✅ **Sample high-volume data** sources where appropriate
- ✅ Use **workspace-based ingestion** for cost allocation

---

## 📱 Application Insights

### Configuration Options (from `azurerm_application_insights.tf`)
- Classic and workspace-based models
- Sampling and filtering capabilities
- Custom telemetry and metrics
- Availability tests and alerts
- Performance profiling

### Application Insights Pricing

#### **Workspace-based (Current Model)**
```
Data Ingestion: Same as Log Analytics ($2.30/GB)
No separate Application Insights billing

Benefits:
- Unified billing with Log Analytics
- Cross-application correlation
- Enhanced query capabilities
```

#### **Typical Data Volumes per Application**
```
Small Application (1K users/day):
- Telemetry: 100MB-1GB/day
- Cost: ~$7-70/month

Medium Application (10K users/day):
- Telemetry: 1-5GB/day
- Cost: ~$70-350/month

Large Application (100K+ users/day):
- Telemetry: 10-50GB/day
- Cost: ~$700-3,500/month
```

#### **Multi-step Web Tests**
```
Standard web tests: $4 per test per month
Multi-step web tests: $10 per test per month

Example:
- 5 endpoints × $4 = $20/month
- 3 complex scenarios × $10 = $30/month
Total: $50/month for availability monitoring
```

---

## 🔍 Network Watcher & Monitoring

### Configuration Options (from network monitoring components)
- Connection monitoring
- Network performance monitoring
- Flow logs and traffic analytics
- Packet capture capabilities
- VPN diagnostics

### Network Watcher Pricing
```
Network Watcher: FREE (enabled by default)

Chargeable Features:
Connection Monitor: $0.80/month per endpoint tested
Traffic Analytics: $0.50/GB processed
Flow Logs Storage: Standard storage rates
Packet Capture: Standard storage rates

Example Medium Organization:
- 20 endpoints monitored: $16/month
- 100GB flow logs: ~$2/month storage + $50 processing
Total: ~$68/month
```

---

## 🚨 Alert Rules & Action Groups

### Azure Monitor Alerts Pricing
```
Metric alerts: $0.10/month per metric alert rule
Log alerts: $1.50/month per alert rule
Activity log alerts: FREE

Action Groups:
- Email: FREE (up to 1,000 emails/month)
- SMS: $0.15 per SMS
- Voice: $0.035 per voice call
- Webhooks: $0.30 per 100,000 webhook calls
- Logic Apps: Separate Logic App pricing applies

Example Alert Configuration:
- 50 metric alerts: $5/month
- 10 log alerts: $15/month
- 100 SMS notifications: $15/month
Total: ~$35/month
```

---

## 🔄 Backup & Recovery Services

### Azure Backup Pricing
```
Protected Instance Types:
- Files/Folders: $10/month per protected instance
- Azure VMs: $10/month per protected instance
- SQL in Azure VM: $15/month per protected instance
- SAP HANA in Azure VM: $20/month per protected instance

Storage:
- First 50GB: FREE per protected instance
- Additional storage: $0.10/GB/month (LRS)
- GRS storage: $0.20/GB/month

Data Transfer:
- Backup data ingress: FREE
- Restore data egress: Standard data transfer rates
```

### Site Recovery Pricing
```
Per Protected Instance:
- Azure VM to Azure: $25/month
- Physical/VMware to Azure: $25/month
- Hyper-V to Azure: $25/month

Storage: Standard storage account rates
Network: Standard data transfer rates
```

### Backup Cost Examples

#### **Small Environment**
```
Resources:
- 10 Azure VMs
- 5 SQL databases
- 1TB total backup data

Monthly Cost:
- VM instances: 10 × $10 = $100
- SQL instances: 5 × $15 = $75
- Storage (1TB): $102 (after 500GB free)
Total: ~$277/month
```

#### **Medium Environment**
```
Resources:
- 50 Azure VMs
- 20 SQL databases
- 10TB total backup data

Monthly Cost:
- VM instances: 50 × $10 = $500
- SQL instances: 20 × $15 = $300
- Storage (9.5TB): $975 (after 2.5TB free)
Total: ~$1,775/month
```

---

## 🔐 Azure Security Center (Microsoft Defender for Cloud)

### Pricing Tiers
```
Free Tier:
- Security recommendations
- Security score
- Basic threat detection

Standard Tier (per resource/month):
- Virtual Machines: $15/month
- SQL Servers: $15/month
- Storage Accounts: $10/month
- Kubernetes: $7/month per vCore
- Container Registries: $0.29/month per image
- Key Vaults: $0.02/month per transaction (10K+)
```

### Defender Cost Examples

#### **Small Organization**
```
Resources:
- 10 VMs: 10 × $15 = $150/month
- 3 SQL servers: 3 × $15 = $45/month
- 5 storage accounts: 5 × $10 = $50/month
Total: ~$245/month
```

#### **Medium Organization**
```
Resources:
- 50 VMs: $750/month
- 10 SQL servers: $150/month
- 20 storage accounts: $200/month
- 2 AKS clusters (20 cores): $140/month
Total: ~$1,240/month
```

---

## 📊 Security & Monitoring Cost Summary by Environment

### Small Organization (10-50 employees)
| Service Category | Dev | Staging | Production | Monthly Total |
|------------------|-----|---------|------------|---------------|
| **Key Vault** | $6 | $10 | $25 | $41 |
| **Log Analytics** | $50 | $100 | $300 | $450 |
| **Application Insights** | $20 | $50 | $150 | $220 |
| **Backup Services** | $25 | $75 | $200 | $300 |
| **Security Center** | $50 | $100 | $200 | $350 |
| **Monitoring & Alerts** | $10 | $20 | $50 | $80 |
| **Total** | **$161** | **$355** | **$925** | **$1,441** |

### Medium Organization (50-200 employees)
| Service Category | Dev | Staging | Production | Monthly Total |
|------------------|-----|---------|------------|---------------|
| **Key Vault** | $15 | $30 | $75 | $120 |
| **Log Analytics** | $200 | $500 | $1,500 | $2,200 |
| **Application Insights** | $100 | $250 | $750 | $1,100 |
| **Microsoft Sentinel** | $0 | $500 | $2,000 | $2,500 |
| **Backup Services** | $100 | $300 | $800 | $1,200 |
| **Security Center** | $200 | $500 | $1,000 | $1,700 |
| **Network Monitoring** | $20 | $40 | $100 | $160 |
| **Total** | **$635** | **$2,120** | **$6,225** | **$8,980** |

### Large Enterprise (200+ employees)
| Service Category | Dev | Staging | Production | Monthly Total |
|------------------|-----|---------|------------|---------------|
| **Key Vault Premium** | $50 | $150 | $500 | $700 |
| **Log Analytics** | $1,000 | $3,000 | $10,000 | $14,000 |
| **Application Insights** | $500 | $1,500 | $5,000 | $7,000 |
| **Microsoft Sentinel** | $500 | $2,000 | $15,000 | $17,500 |
| **Backup & DR** | $500 | $1,500 | $5,000 | $7,000 |
| **Security Center** | $500 | $2,000 | $8,000 | $10,500 |
| **Network Monitoring** | $100 | $300 | $1,000 | $1,400 |
| **Compliance Tools** | $200 | $500 | $2,000 | $2,700 |
| **Total** | **$3,350** | **$10,950** | **$46,500** | **$60,800** |

---

## 🎯 Security & Monitoring Cost Optimization Strategies

### 1. Data Ingestion Optimization
- ✅ **Filter logs at source** (reduce unnecessary verbose logging)
- ✅ **Use sampling** for high-volume, low-value telemetry
- ✅ **Implement log levels** appropriately (ERROR, WARN vs DEBUG, TRACE)
- ✅ **Configure retention policies** based on compliance requirements
- **Potential Savings: 30-60%**

### 2. Smart Alerting
- ✅ **Consolidate related alerts** to avoid noise and costs
- ✅ **Use metric alerts** over log alerts when possible (cheaper)
- ✅ **Implement alert suppression** to avoid alert storms
- ✅ **Use free action groups** (email) for non-critical alerts
- **Potential Savings: 20-40%**

### 3. Monitoring Architecture
- ✅ **Centralize Log Analytics workspaces** for cost consolidation
- ✅ **Use workspace-based Application Insights**
- ✅ **Implement commitment tiers** for predictable log volumes
- ✅ **Cross-workspace queries** to reduce duplicate data ingestion
- **Potential Savings: 15-25%**

### 4. Backup Optimization
- ✅ **Implement tiered backup policies** (daily, weekly, monthly, yearly)
- ✅ **Use appropriate retention periods** for different data types
- ✅ **Leverage free storage tiers** (first 50GB per protected instance)
- ✅ **Consider LRS vs GRS** based on recovery requirements
- **Potential Savings: 25-50%**

### 5. Security Tool Right-sizing
- ✅ **Enable Defender selectively** (not all resources need premium protection)
- ✅ **Use Standard tier Key Vault** unless HSM compliance required
- ✅ **Implement just-in-time VM access** to reduce attack surface and monitoring
- ✅ **Leverage free security features** before premium upgrades
- **Potential Savings: 30-50%**

---

## ⚠️ Hidden Security & Monitoring Costs to Watch

1. **Log Analytics Data Retention**: Extended retention beyond 31 days
2. **Verbose Application Logging**: Debug/trace logs in production
3. **Unrestricted Log Ingestion**: No filtering or sampling policies
4. **Over-alerting**: Too many log-based alerts vs metric alerts
5. **Duplicate Telemetry**: Same data ingested through multiple paths
6. **Backup Storage Growth**: Retention policies not aligned with requirements
7. **Security Center Overuse**: Enabling premium features for low-risk resources
8. **Network Flow Logs**: High-volume network diagnostics data
9. **Cross-Region Log Analytics**: Data transfer costs for centralized logging
10. **Development Environment Monitoring**: Full production-level monitoring in dev

---

## 🔍 Monitoring & Cost Control Best Practices

### Key Metrics to Monitor
- **Daily log ingestion volume**: Track growth trends
- **Alert rule effectiveness**: Signal vs noise ratio
- **Backup storage growth**: Retention policy compliance
- **Security Center coverage**: Cost vs risk assessment
- **Query performance**: Expensive Log Analytics queries

### Cost Alerts to Implement
```
Log Analytics: >$500/month increase
Application Insights: >100GB/day ingestion spike
Backup Storage: >2TB growth per month
Security Center: >$1,000/month increase
Key Vault: >100K operations/day
```

### Automation Opportunities
- **Log Analytics commitment tier** adjustment based on volume trends
- **Backup policy automation** based on resource tags
- **Alert rule management** using Infrastructure as Code
- **Data retention policies** enforcement
- **Security Center policy** assignment automation

---

## 📈 ROI Considerations for Security & Monitoring

### Security Investment ROI
```
Cost of Security Breach:
- Average data breach cost: $4.45M (2023 IBM study)
- Regulatory fines: $10K-$50M+ (GDPR, HIPAA, etc.)
- Downtime costs: $5,600/minute average

Security Monitoring Investment:
- Comprehensive security: $5K-50K/month
- Early threat detection value: 200x+ ROI
- Compliance requirement: Often mandatory
```

### Monitoring Investment ROI
```
Cost of Downtime:
- Application downtime: $5,600/minute average
- Critical system outage: $100K-1M+ per incident
- Performance degradation: 10-50% revenue impact

Monitoring Investment:
- Comprehensive monitoring: $2K-20K/month
- MTTR reduction: 60-80% improvement
- Proactive issue prevention: 5-10x ROI
```

---

*This analysis is based on East US pricing as of 2024. Security and monitoring costs vary significantly based on data volumes, retention requirements, and compliance needs. Regular review and optimization of these services is essential for cost control.*