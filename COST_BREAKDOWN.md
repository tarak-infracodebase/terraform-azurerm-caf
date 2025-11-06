# Azure CAF Terraform Module - Comprehensive Cost Breakdown

This document provides a detailed cost analysis of all Azure resources that can be provisioned using the Azure Cloud Adoption Framework (CAF) Terraform module. The module supports **300+ distinct Azure resource types** across all major service categories.

## 📊 Executive Summary

The CAF Terraform module can provision Azure environments ranging from **$100/month** for small development environments to **$100,000+/month** for enterprise-scale production deployments. Cost varies dramatically based on:

- Resource types and SKUs selected
- Usage patterns and scale
- Regional deployment choices
- Redundancy and availability requirements
- Data transfer and storage needs

## 💰 Cost Categories Overview

| Cost Category | Monthly Range | Key Drivers |
|---------------|---------------|-------------|
| **Very High Cost** | $10,000+ | VMware solutions, Dedicated hosts, SQL Managed Instance, Synapse |
| **High Cost** | $1,000-$10,000 | Large VMs, AKS clusters, Cosmos DB, Virtual WAN, Application Insights |
| **Moderate Cost** | $100-$1,000 | SQL databases, storage, API Management, networking gateways |
| **Low/Usage-Based** | $1-$100 | Serverless functions, basic storage, minimal compute |
| **Minimal/Free** | $0-$10 | Resource groups, managed identities, basic networking |

---

## 🏗️ COMPUTE RESOURCES

### Virtual Machines & Scale Sets
**Cost Model**: Per-hour + storage + licensing
**Price Range**: $30-$5,000+ per VM per month

| Resource | Typical Monthly Cost | Cost Drivers |
|----------|---------------------|--------------|
| `azurerm_linux_virtual_machine` | $30-$2,000 | VM size, region, reserved instances |
| `azurerm_windows_virtual_machine` | $50-$3,000 | Includes Windows licensing |
| `azurerm_virtual_machine_scale_set` | $100-$20,000+ | Auto-scaling, node count |
| `azurerm_managed_disk` | $4-$500 | Size, performance tier (Standard/Premium SSD) |

**Cost Optimization**:
- Use **Azure Reserved Instances** (up to 72% savings)
- Enable **Azure Hybrid Benefit** for Windows licensing
- Right-size VMs using Azure Advisor recommendations
- Use **Spot VMs** for interruptible workloads (90% savings)

### Container Services
**Cost Model**: Per-node + load balancer + storage

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_kubernetes_cluster` | $150-$5,000+ | Standard_D2s_v3 nodes: ~$70/month each |
| `azurerm_container_registry` | $5-$500 | Basic: $5, Standard: $20, Premium: $50 |
| `azurerm_container_group` | $15-$300 | Per-second billing, varies by CPU/memory |

### Specialty Compute (⚠️ VERY HIGH COST)

| Resource | Typical Monthly Cost | Warning |
|----------|---------------------|---------|
| `azurerm_dedicated_host` | $3,000-$8,000+ | Single-tenant physical servers |
| `azurerm_redhat_openshift_cluster` | $2,500-$10,000+ | Managed OpenShift platform |
| `azurerm_vmware_private_cloud` | $20,000-$100,000+ | 3-node minimum cluster |

---

## 🗄️ DATABASE SERVICES

### SQL Server
**Cost Model**: DTU/vCore + storage + backup

| Resource | Typical Monthly Cost | SKU Examples |
|----------|---------------------|--------------|
| `azurerm_mssql_database` | $5-$15,000+ | Basic: $5, S2: $30, P1: $465, P15: $7,000+ |
| `azurerm_mssql_managed_instance` | $900-$20,000+ | GP Gen5 2vCore: ~$900/month minimum |
| `azurerm_mssql_elasticpool` | $200-$10,000+ | Shared resources across databases |

### Open Source Databases
**Cost Model**: vCore + storage + backup

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_mysql_flexible_server` | $15-$2,000+ | B1ms: $15, D2s_v3: $140, zone redundant +100% |
| `azurerm_postgresql_flexible_server` | $15-$2,000+ | Similar pricing to MySQL |
| `azurerm_mariadb_server` | $15-$1,500+ | Legacy service, consider migration |

### NoSQL Databases (⚠️ HIGH COST POTENTIAL)

| Resource | Typical Monthly Cost | Cost Driver |
|----------|---------------------|-------------|
| `azurerm_cosmosdb_account` | $25-$10,000+ | Request Units (RU/s): 400 RU/s = $25/month |
| `azurerm_redis_cache` | $20-$2,000+ | Basic 1GB: $20, Premium 6GB: $320 |

**Cosmos DB Cost Warning**: Can become very expensive quickly. 1,000 RU/s = $60/month, 10,000 RU/s = $600/month.

---

## 💾 STORAGE SERVICES

### Storage Accounts
**Cost Model**: Capacity + transactions + data transfer

| Storage Tier | Cost per GB/Month | Use Case |
|--------------|------------------|----------|
| Premium SSD | $0.15-$0.30 | High IOPS requirements |
| Standard SSD | $0.05-$0.10 | Balanced performance |
| Standard HDD | $0.02-$0.04 | Archival, backup |
| Cool Tier | $0.01-$0.02 | Infrequently accessed |
| Archive Tier | $0.00099-$0.002 | Long-term archival |

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_storage_account` | $10-$10,000+ | Highly variable based on usage |
| `azurerm_netapp_files` ⚠️ | $500-$10,000+ | Premium enterprise storage |

### Backup & Recovery
**Cost Model**: Protected instances + storage + retention

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_recovery_services_vault` | $5-$500+ | Per VM backup: ~$5/month |
| `azurerm_backup_policy_vm` | Included | Backup frequency affects storage costs |

---

## 🌐 NETWORKING SERVICES

### Core Networking (Mostly Low Cost)
**Cost Model**: Fixed monthly + data transfer

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_virtual_network` | FREE | No charge for VNets |
| `azurerm_public_ip` | $3-$4 | Basic: $3, Standard: $4 |
| `azurerm_load_balancer` | $18-$25+ | Standard: $18 + $5 per rule |
| `azurerm_nat_gateway` | $33 + $0.045/GB processed | Per-gateway + data charges |

### Advanced Networking (⚠️ HIGH COST)

| Resource | Typical Monthly Cost | Warning |
|----------|---------------------|---------|
| `azurerm_application_gateway` | $140-$500+ | v2 Standard: $140 + capacity units |
| `azurerm_firewall` | $1,250+ | Premium: $1,250/month + data processing |
| `azurerm_virtual_network_gateway` | $140-$520 | VpnGw1: $140, VpnGw3: $370, ErGw3AZ: $520 |
| `azurerm_express_route_circuit` | $55-$8,000+ | 50Mbps: $55, 10Gbps: $8,000 + port fees |
| `azurerm_virtual_wan` | $250+ per hub | Plus data processing charges |
| `azurerm_bastion_host` | $87-$140 | Basic: $87, Standard: $140 |

### Private Connectivity

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_private_endpoint` | $7.30 | Per endpoint |
| `azurerm_private_dns_zone` | FREE | No charge for private DNS zones |

### CDN & Content Delivery

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_cdn_profile` | $0.087/GB + $0.0075 per 10K requests | Usage-based |
| `azurerm_frontdoor` | $22 + $0.035/GB processed | Global load balancer |

---

## 🌐 WEB & APPLICATION SERVICES

### App Service Plans
**Cost Model**: Tier-based pricing

| Tier | Monthly Cost | Specifications |
|------|-------------|----------------|
| Free | $0 | Shared compute, 1GB disk, 165min/day |
| Shared | $9.67 | Shared compute, custom domains |
| Basic B1 | $54.75 | 1.75GB RAM, 10GB storage |
| Standard S1 | $73 | Auto-scale, staging slots |
| Premium P1V3 | $146 | Dedicated compute, VNet integration |
| Isolated I1V2 | $438 | App Service Environment |

**⚠️ VERY HIGH COST**: App Service Environment (ASE) starts at ~$1,000/month for the dedicated stamp.

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_app_service` | Included in ASP | Multiple apps can share one plan |
| `azurerm_function_app` | $0-$500+ | Consumption: pay-per-execution, Premium: fixed cost |

### Logic Apps
**Cost Model**: Per-action pricing

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_logic_app_workflow` | $0.000025 per action | Can add up with high-frequency workflows |
| `azurerm_integration_service_environment` ⚠️ | $2,000+ | Dedicated ISE for enterprise |

---

## 🔗 INTEGRATION & MESSAGING

### Service Bus
**Cost Model**: Tier + message volume

| Tier | Monthly Cost | Message Quota |
|------|-------------|---------------|
| Basic | $0.05 per million operations | Queues only |
| Standard | $10 + operations | Topics and subscriptions |
| Premium | $677.35 | Dedicated resources, 1 messaging unit |

### Event Processing

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_eventhub_namespace` | $11.30 | Basic with 1 throughput unit |
| `azurerm_eventgrid_topic` | $0.60 per million operations | Usage-based |
| `azurerm_signalr_service` | $50+ | Free: 20 concurrent connections, Standard: $50/unit |

---

## 📊 ANALYTICS & BIG DATA

### Synapse Analytics (⚠️ VERY HIGH COST)
**Cost Model**: DWU-based pricing

| Resource | Typical Monthly Cost | Warning |
|----------|---------------------|---------|
| `azurerm_synapse_sql_pool` | $1,500-$50,000+ | DW100c: ~$1,500/month, DW1000c: ~$15,000/month |
| `azurerm_synapse_spark_pool` | $0.42/vCore-hour | Autoscale 3-40 nodes |

### Databricks (⚠️ HIGH COST)
**Cost Model**: VM costs + DBU (Databricks Unit) charges

| Tier | DBU Cost per Hour | Total Cost (including VM) |
|------|------------------|---------------------------|
| Standard | $0.15/DBU | ~$0.50-$2.00 per node-hour |
| Premium | $0.30/DBU | ~$0.65-$2.15 per node-hour |

### Data Factory
**Cost Model**: Pipeline activities + data movement + compute

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_data_factory` | $0.50-$2.00 per 1,000 activities | Plus data movement costs |
| `azurerm_data_factory_integration_runtime_azure_ssis` ⚠️ | $1,000-$10,000+ | Dedicated SSIS runtime |

### Other Analytics

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_databricks_workspace` | $500-$10,000+ | Based on compute clusters |
| `azurerm_kusto_cluster` | $1,000-$20,000+ | Per-node pricing, 2-node minimum |

---

## 🤖 AI & MACHINE LEARNING

### Cognitive Services
**Cost Model**: Per-transaction/API call

| Service Type | Free Tier | Standard Pricing |
|--------------|-----------|-----------------|
| Computer Vision | 5,000 transactions/month | $1 per 1,000 transactions |
| Speech Services | 5 hours audio/month | $1 per audio hour |
| Text Analytics | 5,000 text records/month | $2 per 1,000 text records |
| OpenAI (GPT) | N/A | $0.002 per 1k tokens (GPT-3.5) |

**Warning**: OpenAI services can become expensive with high usage. GPT-4: $0.03-$0.06 per 1k tokens.

### Machine Learning

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_machine_learning_workspace` | FREE | No cost for workspace itself |
| `azurerm_machine_learning_compute_instance` | $150-$2,000+ | Based on VM size |

### Search & Maps

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_search_service` | FREE-$2,000+ | Free: 50MB, Basic: $250, Standard: $1,000 |
| `azurerm_maps_account` | $0.50 per 1,000 transactions | Gen1 pricing |

---

## 🌐 IOT & DIGITAL SERVICES

### IoT Hub
**Cost Model**: Tier-based + message volume

| Tier | Monthly Cost | Daily Message Quota |
|------|-------------|-------------------|
| Free F1 | $0 | 8,000 messages |
| Basic B1 | $10 | 400,000 messages |
| Standard S1 | $25 | 400,000 messages |
| Standard S2 | $250 | 6 million messages |

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_iothub` | $10-$5,000+ | Scales with tier and units |
| `azurerm_iotcentral_application` | $0-$2+ per device | ST0: Free, ST1: $0.40, ST2: $2 |
| `azurerm_digital_twins_instance` | $1.50 per 1,000 operations | Usage-based |

---

## 🔐 SECURITY & IDENTITY

### Key Vault
**Cost Model**: Tier + operations

| Tier | Monthly Cost | Operations |
|------|-------------|------------|
| Standard | $0.03 per 10,000 operations | Software keys |
| Premium | $1 per HSM key per month | Hardware security module |

### Advanced Security (⚠️ HIGH COST)

| Resource | Typical Monthly Cost | Warning |
|----------|---------------------|---------|
| `azurerm_sentinel_*` | $2-$5 per GB ingested | Can be $1,000s/month with high log volume |
| `azurerm_security_center_storage_defender` | $10 per storage account | Per-account monthly fee |

---

## 📊 MONITORING & MANAGEMENT

### Log Analytics
**Cost Model**: Data ingestion + retention

| Pricing Tier | Cost per GB | Retention |
|--------------|-------------|-----------|
| PerGB2018 | $2.30 per GB | 30 days included, $0.10/GB/month additional |
| CapacityReservation | $1,150 for 100GB/day | Commitment pricing, 2-year term |

**Warning**: Log Analytics can become expensive quickly. 10GB/day = $700/month, 100GB/day = $7,000/month.

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_log_analytics_workspace` | $50-$10,000+ | Based on data ingestion volume |
| `azurerm_application_insights` | $2.30 per GB | Same as Log Analytics pricing |

---

## 🏛️ GOVERNANCE & SPECIALIZED SERVICES

### API Management
**Cost Model**: Per-unit pricing

| Tier | Monthly Cost | Capacity |
|------|-------------|----------|
| Consumption | $3.50 per million calls | Serverless |
| Developer | $55 | 1 unit, no SLA |
| Basic | $140 | 2 units |
| Standard | $665 | 4 units |
| Premium | $2,940 | 4 units, multi-region |

### Other Services

| Resource | Typical Monthly Cost | Notes |
|----------|---------------------|--------|
| `azurerm_purview_account` ⚠️ | $1,500+ | Data governance, capacity-based |
| `azurerm_communication_service` | Usage-based | SMS: $0.0075/message, Voice varies |
| `azurerm_powerbi_embedded` | $1,000+ per SKU | A1: $1,000, A2: $2,000, etc. |

---

## 💡 COST OPTIMIZATION STRATEGIES

### 1. Reserved Instances & Savings Plans
- **VMs**: Up to 72% savings with 3-year commitment
- **SQL Database**: Up to 55% savings
- **Cosmos DB**: Up to 65% savings with reserved capacity

### 2. Right-Sizing Resources
- Use **Azure Advisor** for right-sizing recommendations
- Start with smaller SKUs and scale up as needed
- Monitor utilization with **Azure Monitor**

### 3. Lifecycle Management
- **Storage**: Auto-move to Cool/Archive tiers
- **VMs**: Auto-shutdown for dev/test environments
- **Snapshots**: Implement retention policies

### 4. Optimize Data Transfer
- Keep resources in same region when possible
- Use **Azure CDN** for global content delivery
- Minimize cross-region data transfer

### 5. Use Serverless When Possible
- **Functions**: Pay only for execution time
- **Logic Apps**: Consumption plan for intermittent workflows
- **API Management**: Consumption tier for light usage

### 6. Monitor and Alert
- Set up **budgets** and **cost alerts**
- Use **Cost Analysis** for spending patterns
- Tag resources for cost allocation

## 🚨 HIDDEN COST WARNINGS

### Data Transfer Charges
- **Outbound data transfer**: $0.087 per GB (first 100GB free monthly)
- **Cross-region transfer**: Can be significant for replicated services
- **ExpressRoute**: Metered plans charge for outbound data

### Storage Transaction Costs
- **Hot storage**: $0.0004 per 10,000 read operations
- **Cool storage**: $0.01 per 10,000 read operations
- **Archive storage**: $5 per 10,000 read operations + rehydration costs

### Premium Features
- **Availability Zones**: Additional cost for zone-redundant services
- **Premium SKUs**: Often 2-10x cost of standard tiers
- **Managed services**: Convenience comes with significant markup

### Backup and Disaster Recovery
- **Geo-redundant backup**: Double the storage cost
- **Long-term retention**: Can accumulate over time
- **Cross-region restore**: Data transfer charges apply

---

## 📋 COST ESTIMATION EXAMPLES

### Small Development Environment (~$300/month)
- 2x Standard_B2s VMs (Linux): $60
- Basic SQL Database: $5
- Standard Storage Account (100GB): $5
- Basic Load Balancer: Free
- VNet and NSGs: Free
- Log Analytics (5GB/month): $12
- **Total: ~$82/month** (plus misc. services)

### Medium Production Environment (~$3,000/month)
- 5x Standard_D4s_v3 VMs: $750
- Standard S2 SQL Database: $30
- Premium Storage Account (1TB): $150
- Application Gateway v2: $140
- VPN Gateway: $140
- Log Analytics (50GB/month): $115
- Application Insights: $50
- **Total: ~$1,375/month** (plus additional services)

### Large Enterprise Environment (~$30,000/month)
- AKS cluster (10 nodes): $1,400
- SQL Managed Instance: $900
- Premium Redis Cache: $320
- Azure Firewall Premium: $1,250
- Virtual WAN (2 hubs): $500
- Log Analytics (500GB/month): $1,150
- Multiple storage accounts: $500
- ExpressRoute (1Gbps): $1,000
- **Core services: ~$6,020/month** (scales to $30k+ with full enterprise stack)

---

## 🔗 COST MONITORING RESOURCES

### Built-in Azure Tools
- **Azure Cost Management + Billing**: Native cost analysis
- **Azure Advisor**: Right-sizing recommendations
- **Azure Budgets**: Spending alerts and limits
- **Azure Pricing Calculator**: Pre-deployment estimation

### Third-Party Tools
- **CloudHealth**: Multi-cloud cost management
- **Cloudyn**: Advanced cost analytics (now part of Azure Cost Management)
- **Turbonomic**: Application-aware cost optimization

### Terraform Cost Tools
- **Infracost**: Cost estimation for Terraform code
- **Azure FinOps Toolkit**: Cost optimization for Azure resources
- **Terraform Cloud**: Cost estimation integration

---

## 📞 GETTING HELP

For cost optimization assistance:
1. Contact **Azure Customer Success** team
2. Engage **Azure Solution Architects**
3. Use **Azure Cost Management** support
4. Consider **Azure FinOps** best practices training

---

**Disclaimer**: Costs shown are estimates based on East US 2 region pricing as of 2024. Actual costs may vary based on region, usage patterns, enterprise agreements, and current Azure pricing. Always use the Azure Pricing Calculator for accurate estimates and consult the latest Azure pricing documentation.

**Last Updated**: January 2024
**Pricing Source**: [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)