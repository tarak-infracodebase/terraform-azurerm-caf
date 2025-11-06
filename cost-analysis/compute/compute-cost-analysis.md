# Compute Services - Cost Analysis

## Overview
Compute services typically represent 40-60% of total Azure infrastructure costs. This analysis covers all compute resources supported by the CAF module.

---

## 🚀 Azure Kubernetes Service (AKS)

### Configuration Options (from `compute_aks_clusters.tf`)
- Node pools with different VM SKUs
- Auto-scaling enabled
- Azure CNI networking
- Managed identity integration
- Log Analytics integration

### Cost Structure
| Component | Cost Driver | Monthly Cost Range |
|-----------|-------------|-------------------|
| **Control Plane** | Free (managed) | $0 |
| **Worker Nodes** | VM size × quantity × hours | $200 - $5,000+ |
| **Storage** | OS + Data disks | $50 - $500 |
| **Load Balancer** | Standard LB + rules | $18 - $100 |
| **Outbound IP** | Static IPs | $3.65 per IP |

### Example AKS Configurations

#### **Development Environment**
```
Node Pool: 2x Standard_B2ms (2 vCPU, 8GB RAM)
Monthly Cost: ~$140
- VMs: 2 × $70 = $140
- Storage: 2 × 30GB Premium SSD = $10
- Load Balancer: $18
Total: ~$168/month
```

#### **Production Environment**
```
System Pool: 3x Standard_D4s_v3 (4 vCPU, 16GB RAM)
User Pool: 6x Standard_D8s_v3 (8 vCPU, 32GB RAM)
Monthly Cost: ~$2,800
- System VMs: 3 × $140 = $420
- User VMs: 6 × $280 = $1,680
- Storage: Premium SSD disks = $200
- Load Balancer Standard: $50
- Monitoring & Logs: $150
Total: ~$2,500/month
```

#### **Enterprise Scale**
```
Multiple Node Pools: 20-50 nodes
Monthly Cost: $8,000 - $20,000+
- Includes: GPU nodes, spot instances, reserved capacity
- Add: Container registry, private endpoints, advanced monitoring
```

### Cost Optimization Tips
- ✅ Use **Spot Node Pools** (up to 90% savings for fault-tolerant workloads)
- ✅ Enable **Cluster Autoscaler** to scale down during off-hours
- ✅ Use **Reserved Instances** (30-60% savings for 1-3 year commitments)
- ✅ Right-size node pools based on actual resource usage
- ✅ Use **Burstable VM series** (B-series) for development environments

---

## 🖥️ Virtual Machines

### Configuration Options (from `compute_virtual_machines.tf`)
- Multiple VM sizes and families
- Windows and Linux support
- Managed disks (Standard/Premium SSD)
- Backup integration
- Auto-shutdown policies

### Cost Structure
| Component | Cost Driver | Monthly Cost Range |
|-----------|-------------|-------------------|
| **Compute** | VM size × hours | $20 - $2,000+ |
| **Storage** | OS + Data disk size/type | $5 - $500 |
| **Networking** | Bandwidth, Load Balancer | $10 - $100 |
| **Backup** | Protected data size | $5 - $50 |
| **Windows License** | Core count (if applicable) | $0 - $200 |

### VM Sizing Guide

#### **Development VMs**
```
Standard_B2s (2 vCPU, 4GB RAM)
Linux: $31/month
Windows: $62/month (includes license)
Use Case: Development, testing, small applications
```

#### **General Purpose Production**
```
Standard_D4s_v3 (4 vCPU, 16GB RAM)
Linux: $140/month
Windows: $224/month
Use Case: Web servers, small databases, CI/CD agents
```

#### **Memory Optimized**
```
Standard_E8s_v3 (8 vCPU, 64GB RAM)
Linux: $410/month
Windows: $576/month
Use Case: In-memory databases, large caching layers
```

#### **Compute Optimized**
```
Standard_F16s_v2 (16 vCPU, 32GB RAM)
Linux: $485/month
Windows: $728/month
Use Case: CPU-intensive applications, batch processing
```

### Reserved Instance Savings
| Term | Discount | Break-even |
|------|----------|------------|
| **1 Year** | ~30% | 8-9 months usage |
| **3 Year** | ~50% | 18 months usage |

---

## 🔄 Virtual Machine Scale Sets (VMSS)

### Configuration (from `compute_virtual_machine_scale_sets.tf`)
- Auto-scaling based on metrics
- Multiple zones for high availability
- Custom VM images support
- Application Gateway integration

### Cost Considerations
- **Base Cost**: Same as individual VMs × instance count
- **Auto-scaling**: Costs fluctuate with demand
- **Load Balancer**: Additional $18-50/month per LB
- **Application Gateway**: $18-250/month based on features

### Example VMSS Costs
```
Web Tier VMSS: 3-10 Standard_D2s_v3 instances
Min Cost (3 instances): 3 × $70 = $210/month
Max Cost (10 instances): 10 × $70 = $700/month
Average (70% scaling): ~$490/month
```

---

## 🌐 App Service Plans

### Configuration (from `app_service_*.tf`)
- Multiple tiers: Free, Basic, Standard, Premium
- Auto-scaling capabilities
- Integrated development tools
- SSL certificate management

### Pricing Tiers

#### **Development**
```
Free (F1): $0/month
- 1GB storage, 165MB memory
- Custom domains not supported
- 60 minutes/day CPU time limit
```

#### **Basic Production**
```
Basic B1: $13/month
- 10GB storage, 1.75GB memory
- Custom domains, manual scaling
- No auto-scaling or staging slots
```

#### **Standard Production**
```
Standard S1: $56/month
- 50GB storage, 1.75GB memory
- Auto-scaling up to 10 instances
- 5 staging slots, custom SSL
```

#### **Premium Production**
```
Premium P1V2: $146/month
- 250GB storage, 3.5GB memory
- Auto-scaling up to 30 instances
- VNet integration, private endpoints
```

### App Service Cost Optimization
- ✅ Use **Consumption plan** for Function Apps (pay-per-execution)
- ✅ Scale down during off-hours using auto-scaling rules
- ✅ Use **Reserved Instances** for predictable workloads
- ✅ Consolidate apps on shared App Service Plans where possible

---

## ⚡ Azure Functions

### Configuration (from `function_app.tf`)
- Consumption plan (serverless)
- Premium plan (dedicated)
- App Service Plan hosting
- Storage account integration

### Pricing Models

#### **Consumption Plan (Serverless)**
```
Charges:
- $0.000016 per GB-second of memory consumption
- $0.20 per million executions
- First 1M executions free monthly
- First 400,000 GB-seconds free monthly

Example:
Low Usage: $5-20/month
Medium Usage: $50-200/month
High Usage: $200-1000+/month
```

#### **Premium Plan**
```
EP1: $146/month (1 vCPU, 3.5GB RAM)
EP2: $292/month (2 vCPU, 7GB RAM)
EP3: $584/month (4 vCPU, 14GB RAM)

Benefits:
- Pre-warmed instances (no cold start)
- VNet connectivity
- Unlimited execution duration
```

---

## 🏗️ Container Services

### Azure Container Instances (ACI)
Configuration from `container_groups.tf`:

#### **Pricing (per second)**
```
CPU: $0.0000012 per vCPU-second
Memory: $0.00000017 per GB-second

Example Costs:
1 vCPU, 1GB RAM (24/7): ~$31/month
2 vCPU, 4GB RAM (8hrs/day): ~$25/month
4 vCPU, 8GB RAM (24/7): ~$180/month
```

### Azure Container Registry (ACR)
Configuration from `azure_container_registries.tf`:

```
Basic: $5/month (10GB storage)
Standard: $20/month (100GB storage)
Premium: $50/month (500GB storage)
+ Geo-replication: Additional regions cost extra
```

---

## 🔧 Batch Services

### Configuration (from `batch_*.tf`)
- Dedicated pools vs auto-pools
- Low-priority VMs support
- Job scheduling and queuing
- Auto-scaling capabilities

### Cost Structure
```
Batch Account: Free
VM Pool Charges:
- Standard VMs: Same as regular VM pricing
- Low-Priority VMs: Up to 80% discount
- Auto-scaling: Pay only for active instances

Example:
10-node Standard_D4s_v3 pool (8 hours/day)
Regular VMs: 10 × $140 × 0.33 = $462/month
Low-Priority VMs: 10 × $28 × 0.33 = $92/month
Savings: 80%
```

---

## 📊 Compute Cost Summary by Environment

### Small Organization (10-50 employees)
| Environment | Monthly Cost | Annual Cost |
|-------------|--------------|-------------|
| **Development** | $500 - $1,500 | $6K - $18K |
| **Staging** | $800 - $2,000 | $9.6K - $24K |
| **Production** | $2,000 - $5,000 | $24K - $60K |
| **Total** | **$3,300 - $8,500** | **$39.6K - $102K** |

### Medium Organization (50-200 employees)
| Environment | Monthly Cost | Annual Cost |
|-------------|--------------|-------------|
| **Development** | $1,500 - $4,000 | $18K - $48K |
| **Staging** | $2,500 - $6,000 | $30K - $72K |
| **Production** | $8,000 - $20,000 | $96K - $240K |
| **Total** | **$12,000 - $30,000** | **$144K - $360K** |

### Large Enterprise (200+ employees)
| Environment | Monthly Cost | Annual Cost |
|-------------|--------------|-------------|
| **Development** | $4,000 - $10,000 | $48K - $120K |
| **Staging** | $8,000 - $15,000 | $96K - $180K |
| **Production** | $25,000 - $100,000+ | $300K - $1.2M+ |
| **Total** | **$37,000 - $125,000+** | **$444K - $1.5M+** |

---

## 🎯 Top 5 Compute Cost Optimization Strategies

### 1. Right-Size Resources
- Monitor CPU/memory utilization for 30 days
- Downsize overprovisioned resources
- **Potential Savings: 20-40%**

### 2. Use Reserved Instances
- Commit to 1-3 year terms for stable workloads
- **Potential Savings: 30-60%**

### 3. Implement Auto-Scaling
- Scale down during off-hours
- Use metrics-based scaling
- **Potential Savings: 15-30%**

### 4. Leverage Spot/Low-Priority VMs
- For fault-tolerant batch processing
- Development and testing environments
- **Potential Savings: 60-90%**

### 5. Optimize Licensing
- Use Azure Hybrid Benefit for Windows/SQL
- Consider Linux alternatives where possible
- **Potential Savings: 30-40%**

---

## ⚠️ Hidden Compute Costs to Watch

1. **Idle Resources**: VMs running 24/7 but utilized <10%
2. **Oversized Disks**: Premium SSD when Standard SSD suffices
3. **Unnecessary High Availability**: Multiple zones for dev environments
4. **License Stacking**: Multiple SQL licenses on same server
5. **Always-On Development**: No auto-shutdown policies
6. **Cross-Region Networking**: Data transfer between regions
7. **Premium Features**: Using premium SKUs for basic workloads

---

*This analysis is based on East US pricing as of 2024. Actual costs may vary based on region, usage patterns, and enterprise agreements.*