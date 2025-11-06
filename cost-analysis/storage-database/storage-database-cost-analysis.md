# Storage & Database Services - Cost Analysis

## Overview
Storage and database services typically represent 20-30% of total Azure infrastructure costs. These costs include data storage, transactions, backup, and compute resources for database services.

---

## 💾 Storage Accounts

### Configuration Options (from `storage_accounts.tf`)
- Multiple performance tiers (Standard, Premium)
- Replication options (LRS, GRS, RA-GRS, ZRS, GZRS)
- Access tiers (Hot, Cool, Archive)
- Customer-managed key encryption
- Private endpoints and network restrictions

### Storage Account Types & Pricing

#### **General Purpose v2 (Recommended)**
| Tier | Use Case | Storage Cost/GB/Month | Transaction Cost |
|------|----------|----------------------|------------------|
| **Hot** | Frequently accessed | $0.0208 (LRS) | $0.0065 per 10K |
| **Cool** | Infrequently accessed | $0.0152 (LRS) | $0.0130 per 10K |
| **Archive** | Long-term backup | $0.00099 (LRS) | $0.65 per 10K |

#### **Premium Performance**
```
Block Blob: $0.1472/GB/month (LRS)
Page Blob: $0.1472/GB/month (LRS)
File Share: $0.1536/GB/month (LRS)

Use Case: High IOPS, low latency requirements
Typical: Database storage, high-performance applications
```

### Replication Costs (Multipliers)
- **LRS (Locally Redundant)**: 1x base cost
- **ZRS (Zone Redundant)**: 1.25x base cost
- **GRS (Geo Redundant)**: 2x base cost
- **RA-GRS (Read Access Geo)**: 2x base cost + read transaction fees
- **GZRS (Geo Zone Redundant)**: 2.5x base cost

### Example Storage Costs

#### **Small Business (100GB mixed data)**
```
Hot Storage: 50GB × $0.0208 = $1.04/month
Cool Storage: 40GB × $0.0152 = $0.61/month
Archive: 10GB × $0.00099 = $0.01/month
Transactions: ~$2/month
Total: ~$3.66/month (LRS)
With GRS: ~$7.32/month
```

#### **Medium Business (10TB mixed data)**
```
Hot Storage: 2TB × $0.0208 = $42.60/month
Cool Storage: 6TB × $0.0152 = $93.60/month
Archive: 2TB × $0.00099 = $2.03/month
Transactions: ~$50/month
Total: ~$188/month (LRS)
With GRS: ~$376/month
```

#### **Enterprise (100TB+ data lake)**
```
Hot Storage: 10TB × $0.0208 = $212/month
Cool Storage: 40TB × $0.0152 = $624/month
Archive: 50TB × $0.00099 = $51/month
Premium: 5TB × $0.1472 = $753/month
Transactions: ~$500/month
Total: ~$2,140/month (mixed replication)
```

### Storage Optimization Strategies
- ✅ Use **lifecycle policies** to move data to cooler tiers automatically
- ✅ Implement **Archive tier** for long-term retention (90% cost savings)
- ✅ Choose **LRS** for non-critical data (50% savings vs GRS)
- ✅ Use **Standard** tier unless high IOPS required
- ✅ Enable **soft delete** carefully (incurs storage costs for deleted data)

---

## 🗄️ Azure SQL Database

### Configuration Options (from `mssql_*.tf`)
- Single databases and elastic pools
- Multiple service tiers (Basic, Standard, Premium, General Purpose, Business Critical)
- Serverless compute option
- Hyperscale for large databases
- Backup retention and geo-redundancy

### SQL Database Pricing Models

#### **DTU-Based Pricing (Legacy)**
```
Basic: $4.90/month (5 DTUs, 2GB)
Standard S2: $30/month (50 DTUs, 250GB)
Premium P2: $465/month (250 DTUs, 500GB)

DTU = Database Transaction Unit (CPU+Memory+IO)
```

#### **vCore-Based Pricing (Recommended)**

**General Purpose Tier:**
```
2 vCore: $730/month (Provisioned), $219/month (Serverless avg)
4 vCore: $1,460/month (Provisioned), $438/month (Serverless avg)
8 vCore: $2,920/month (Provisioned), $876/month (Serverless avg)

Storage: $0.115/GB/month (up to 32TB)
Backup: $0.20/GB/month (beyond 1x database size)
```

**Business Critical Tier:**
```
2 vCore: $1,823/month (includes Always On, read replicas)
4 vCore: $3,646/month
8 vCore: $7,292/month

Storage: $0.25/GB/month
Built-in high availability, disaster recovery
```

### SQL Managed Instance
```
General Purpose:
- 4 vCore: $1,460/month + $0.115/GB storage
- 8 vCore: $2,920/month + $0.115/GB storage

Business Critical:
- 4 vCore: $3,646/month + $0.25/GB storage
- 8 vCore: $7,292/month + $0.25/GB storage

Additional Costs:
- Backup storage: $0.20/GB/month
- VNet Gateway: $142-568/month (if required)
```

### SQL Database Cost Examples

#### **Small Application Database**
```
General Purpose 2 vCore (Serverless)
- Compute: ~$219/month (average usage)
- Storage: 50GB × $0.115 = $5.75/month
- Backup: Minimal (within free tier)
Total: ~$225/month
```

#### **Medium Production Database**
```
General Purpose 4 vCore (Provisioned)
- Compute: $1,460/month
- Storage: 500GB × $0.115 = $57.50/month
- Backup: 100GB × $0.20 = $20/month
Total: ~$1,537/month
```

#### **Mission-Critical Database**
```
Business Critical 8 vCore + Read Replica
- Primary: $7,292/month
- Read Replica: $7,292/month
- Storage: 2TB × $0.25 = $525/month
- Backup: 500GB × $0.20 = $100/month
- Geo-redundant backup: Additional 50%
Total: ~$15,700/month
```

---

## 🐘 PostgreSQL & MySQL

### Configuration (from `postgresql_*.tf`, `mysql_*.tf`)
- Single Server (legacy) and Flexible Server
- Multiple compute tiers and storage options
- High availability and read replicas
- Automated backup and point-in-time restore

### Azure Database for PostgreSQL (Flexible Server)

#### **Compute Pricing**
```
Burstable (B1ms): $12.41/month (1 vCore, 2GB RAM)
General Purpose (D2s_v3): $140.16/month (2 vCore, 8GB RAM)
Memory Optimized (E2s_v3): $179.33/month (2 vCore, 16GB RAM)

High Availability: +100% compute cost
Read Replicas: Full compute cost per replica
```

#### **Storage Pricing**
```
Standard Storage: $0.115/GB/month
IOPS: $0.0577/month per provisioned IOPS (above baseline)
Backup: $0.095/GB/month (beyond 1x database size)

Example: 1TB with 3,000 IOPS
- Storage: 1,024GB × $0.115 = $117.76/month
- IOPS: (3,000 - baseline) × $0.0577 = varies
- Total: ~$120-200/month
```

### MySQL Pricing
Similar structure to PostgreSQL:
```
Flexible Server compute costs identical to PostgreSQL
Storage: $0.115/GB/month
Backup: $0.095/GB/month
```

### Example MySQL/PostgreSQL Costs

#### **Development Database**
```
Burstable B1ms + 100GB storage
- Compute: $12.41/month
- Storage: $11.50/month
- Backup: Minimal
Total: ~$24/month
```

#### **Production Database with HA**
```
General Purpose D4s_v3 + HA + 500GB
- Compute: $280.32/month (with HA)
- Storage: $57.50/month
- Backup: $15/month
Total: ~$353/month
```

---

## 🌌 Cosmos DB

### Configuration (from `cosmos_dbs.tf`)
- Multiple APIs (SQL, MongoDB, Cassandra, Gremlin, Table)
- Provisioned throughput and serverless options
- Global distribution and multi-region writes
- Automatic indexing and partitioning

### Cosmos DB Pricing Models

#### **Provisioned Throughput**
```
Request Units (RU/s): $0.008/hour per 100 RU/s

Examples:
- 400 RU/s: $23.04/month (minimum)
- 1,000 RU/s: $57.60/month
- 10,000 RU/s: $576/month
- 100,000 RU/s: $5,760/month

Storage: $0.25/GB/month
Backup: $0.20/GB/month
```

#### **Serverless**
```
Request Units: $0.285 per million RU consumed
Storage: $0.25/GB/month

Example Usage:
- 10M RU/month: $2.85
- 100M RU/month: $28.50
- 1B RU/month: $285

Break-even: ~650 RU/s constant usage
```

#### **Multi-Region Costs**
```
Additional Regions:
- Each region adds 1x compute cost
- Storage replicated to each region
- Consistency levels affect cost

Example: 2-region deployment with 1,000 RU/s
- Primary region: $57.60/month
- Secondary region: $57.60/month
- Storage: 2 × 10GB × $0.25 = $5/month
Total: ~$120/month
```

### Cosmos DB Cost Examples

#### **Small Application (Serverless)**
```
Usage: 50M RU/month, 5GB storage
- Compute: 50 × $0.285 = $14.25/month
- Storage: 5GB × $0.25 = $1.25/month
Total: ~$15.50/month
```

#### **Medium Application (Provisioned)**
```
5,000 RU/s, 100GB storage, single region
- Compute: $288/month
- Storage: 100GB × $0.25 = $25/month
- Backup: Minimal
Total: ~$313/month
```

#### **Global Application (Multi-region)**
```
20,000 RU/s, 3 regions, 1TB storage
- Compute: 3 × $1,152 = $3,456/month
- Storage: 3 × 1TB × $0.25 = $787.50/month
- Backup: $200/month
Total: ~$4,444/month
```

---

## 🔄 Redis Cache

### Configuration (from `azurerm_redis_caches.tf`)
- Multiple tiers (Basic, Standard, Premium)
- Different cache sizes and features
- Clustering and persistence options
- Data replication and backup

### Redis Cache Pricing

#### **Basic Tier (No SLA)**
```
C0 (250MB): $16.06/month
C1 (1GB): $32.12/month
C2 (2.5GB): $64.24/month
C3 (6GB): $128.48/month
C4 (13GB): $256.96/month
C5 (26GB): $513.92/month
C6 (53GB): $1,027.84/month
```

#### **Standard Tier (With SLA and Replication)**
```
Approximately 2x Basic tier pricing
Includes: Primary/secondary replication, SLA
```

#### **Premium Tier (Advanced Features)**
```
P1 (6GB): $465/month
P2 (13GB): $930/month
P3 (26GB): $1,860/month
P4 (53GB): $3,720/month
P5 (120GB): $7,440/month

Additional Features:
- Redis persistence
- Virtual Network support
- Clustering (P3-P5)
- Geo-replication
```

---

## 📊 Storage & Database Cost Summary by Environment

### Small Organization (10-50 employees)
| Service Category | Dev | Staging | Production | Monthly Total |
|------------------|-----|---------|------------|---------------|
| **Storage Accounts** | $25 | $75 | $300 | $400 |
| **SQL Database** | $50 | $225 | $800 | $1,075 |
| **PostgreSQL/MySQL** | $25 | $50 | $200 | $275 |
| **Redis Cache** | $15 | $32 | $128 | $175 |
| **Cosmos DB** | $15 | $50 | $150 | $215 |
| **Backup & Archive** | $10 | $25 | $100 | $135 |
| **Total** | **$140** | **$457** | **$1,678** | **$2,275** |

### Medium Organization (50-200 employees)
| Service Category | Dev | Staging | Production | Monthly Total |
|------------------|-----|---------|------------|---------------|
| **Storage Accounts** | $100 | $300 | $1,500 | $1,900 |
| **SQL Database** | $200 | $800 | $4,000 | $5,000 |
| **PostgreSQL/MySQL** | $75 | $200 | $1,000 | $1,275 |
| **Redis Cache** | $32 | $128 | $465 | $625 |
| **Cosmos DB** | $50 | $200 | $1,000 | $1,250 |
| **Backup & Archive** | $50 | $150 | $500 | $700 |
| **Total** | **$507** | **$1,778** | **$8,465** | **$10,750** |

### Large Enterprise (200+ employees)
| Service Category | Dev | Staging | Production | Monthly Total |
|------------------|-----|---------|------------|---------------|
| **Storage Accounts** | $500 | $1,500 | $8,000 | $10,000 |
| **SQL Database** | $1,000 | $4,000 | $20,000 | $25,000 |
| **PostgreSQL/MySQL** | $300 | $1,000 | $5,000 | $6,300 |
| **Redis Cache** | $128 | $465 | $1,860 | $2,453 |
| **Cosmos DB** | $200 | $1,000 | $8,000 | $9,200 |
| **Databricks/Synapse** | $500 | $2,000 | $15,000 | $17,500 |
| **Backup & Archive** | $200 | $500 | $2,000 | $2,700 |
| **Total** | **$2,828** | **$10,465** | **$59,860** | **$73,153** |

---

## 🎯 Storage & Database Cost Optimization Strategies

### 1. Data Lifecycle Management
- ✅ Implement **automated tiering** (Hot → Cool → Archive)
- ✅ Use **lifecycle policies** to delete temporary data
- ✅ Configure **appropriate backup retention** periods
- ✅ **Archive old data** not accessed for 90+ days
- **Potential Savings: 40-80%**

### 2. Right-Size Database Resources
- ✅ Use **Serverless SQL** for variable workloads
- ✅ Implement **elastic pools** for multiple databases
- ✅ Monitor **DTU/vCore utilization** and adjust accordingly
- ✅ Use **read replicas** strategically (not for every environment)
- **Potential Savings: 30-50%**

### 3. Storage Optimization
- ✅ Choose appropriate **replication level** (LRS vs GRS)
- ✅ Use **Standard** storage unless Premium IOPS required
- ✅ Implement **compression** before storage
- ✅ **Deduplicate** data where possible
- **Potential Savings: 25-60%**

### 4. Database Technology Selection
- ✅ Use **managed services** instead of VMs for databases
- ✅ Consider **PostgreSQL/MySQL** instead of SQL Server for cost savings
- ✅ Evaluate **Cosmos DB Serverless** for variable workloads
- ✅ Use **Redis Basic** for development/testing
- **Potential Savings: 20-70%**

### 5. Reserved Capacity & Hybrid Benefits
- ✅ **Reserved Capacity** for predictable workloads (1-3 year commitments)
- ✅ **Azure Hybrid Benefit** for SQL Server licenses
- ✅ **Dev/Test pricing** for non-production environments
- **Potential Savings: 30-55%**

---

## ⚠️ Hidden Storage & Database Costs to Watch

1. **Long-term Backup Retention**: Default 7-35 days, but often set higher
2. **Cross-Region Backup**: Geo-redundant backup doubles storage costs
3. **Point-in-Time Recovery**: Extended retention periods increase costs
4. **Unused Provisioned IOPS**: Paying for IOPS you don't use
5. **Development Database Sizes**: Prod-sized data in dev environments
6. **Soft Delete Storage**: Deleted blobs still consume storage for retention period
7. **Transaction Costs**: High transaction volumes on cool/archive storage
8. **Multi-Region Cosmos DB**: Each additional region multiplies costs
9. **Premium Storage Overuse**: Using premium when standard suffices
10. **Always-On Development**: Databases running 24/7 in dev environments

---

## 🔍 Monitoring & Cost Control

### Key Metrics to Track
- **Storage growth rate**: GB/month increase
- **Database utilization**: CPU/DTU usage patterns
- **Transaction patterns**: Read/write ratios and peaks
- **Backup storage consumption**: Retention policy effectiveness
- **Data transfer costs**: Movement between tiers and regions

### Cost Alerts to Implement
```
Storage Account: >$100/month increase
SQL Database: >80% DTU utilization for 7 days
Cosmos DB: >$500/month in single region
Redis Cache: <20% memory utilization for 30 days
Backup Storage: >2x production database size
```

### Automation Opportunities
- **Auto-pause** serverless SQL databases during off-hours
- **Scale down** development databases overnight and weekends
- **Lifecycle policies** for blob storage tiering
- **Elastic pool** auto-scaling based on demand
- **Backup retention** policy automation

---

*This analysis is based on East US pricing as of 2024. Database and storage costs can vary significantly based on usage patterns, data sizes, and performance requirements. Always validate with the Azure Pricing Calculator and monitor actual usage patterns.*