# Azure CAF Cost Comparison Matrix

## 📊 Service Cost Comparison by Environment

### Virtual Machines - Monthly Costs by SKU

| VM SKU | vCPU | RAM | Linux Cost | Windows Cost | Recommended Use |
|--------|------|-----|------------|--------------|----------------|
| **Development Environment** |
| Standard_B1s | 1 | 1GB | $7.59 | $15.18 | Minimal workloads |
| Standard_B1ms | 1 | 2GB | $12.41 | $24.82 | Light development |
| Standard_B2s | 2 | 4GB | $30.37 | $60.74 | Development VMs |
| Standard_B2ms | 2 | 8GB | $62.05 | $124.10 | Development with moderate load |
| **Production Environment** |
| Standard_D2s_v3 | 2 | 8GB | $70.08 | $140.16 | Small production workloads |
| Standard_D4s_v3 | 4 | 16GB | $140.16 | $280.32 | Medium production workloads |
| Standard_D8s_v3 | 8 | 32GB | $280.32 | $560.64 | Large production workloads |
| Standard_E4s_v3 | 4 | 32GB | $204.47 | $288.26 | Memory-intensive applications |

### AKS Cluster Costs - Monthly Estimates

| Configuration | Node Count | Node SKU | Monthly Cost | Use Case |
|---------------|------------|----------|--------------|-----------|
| **Development** |
| Basic Dev | 2 | Standard_B2s | $121 | Learning/testing |
| Standard Dev | 3 | Standard_B4ms | $439 | Team development |
| **Staging** |
| Small Staging | 3 | Standard_D2s_v3 | $420 | Pre-production testing |
| Medium Staging | 5 | Standard_D4s_v3 | $1,401 | Load testing |
| **Production** |
| Small Prod | 6 | Standard_D4s_v3 | $1,681 | Small applications |
| Medium Prod | 10 | Standard_D8s_v3 | $4,204 | Medium scale applications |
| Large Prod | 20 | Standard_D8s_v3 | $8,409 | High scale applications |
| Enterprise | 50+ | Mixed SKUs | $20,000+ | Enterprise scale |

### Database Services - Monthly Cost Comparison

| Service | Configuration | Monthly Cost | Best For |
|---------|---------------|--------------|----------|
| **Azure SQL Database** |
| Basic | 5 DTU, 2GB | $4.90 | Development |
| Standard S2 | 50 DTU, 250GB | $30 | Small production |
| Standard S4 | 200 DTU, 250GB | $238 | Medium production |
| Premium P2 | 250 DTU, 500GB | $465 | High-performance apps |
| GP 2 vCore | 2 vCore, up to 32TB | $730 | General purpose |
| GP 4 vCore | 4 vCore, up to 32TB | $1,460 | Balanced workloads |
| BC 4 vCore | 4 vCore, built-in HA | $3,646 | Mission-critical |
| **PostgreSQL/MySQL** |
| Burstable B1ms | 1 vCore, 2GB RAM | $12.41 | Development |
| GP D2s_v3 | 2 vCore, 8GB RAM | $140.16 | Production |
| MO E2s_v3 | 2 vCore, 16GB RAM | $179.33 | Memory-intensive |
| **Cosmos DB** |
| Serverless | Pay-per-RU | $0.285/M RU | Variable workloads |
| Provisioned 400 RU/s | Minimum | $23.04 | Small consistent load |
| Provisioned 1K RU/s | 1,000 RU/s | $57.60 | Medium load |
| Provisioned 10K RU/s | 10,000 RU/s | $576 | High throughput |

### Storage Account Costs - Per GB/Month

| Tier | Hot | Cool | Archive | Best Use Case |
|------|-----|------|---------|---------------|
| **Standard LRS** | $0.0208 | $0.0152 | $0.00099 | Single region |
| **Standard ZRS** | $0.026 | $0.019 | $0.00124 | Zone redundant |
| **Standard GRS** | $0.0416 | $0.0304 | $0.00198 | Geo redundant |
| **Standard RA-GRS** | $0.0520 | $0.0380 | $0.00248 | Read access geo |
| **Premium LRS** | $0.1472 | N/A | N/A | High IOPS |

### Networking Costs - Monthly Comparison

| Service | Configuration | Monthly Cost | Use Case |
|---------|---------------|--------------|-----------|
| **Load Balancer** |
| Basic | Free tier | $0 | Development only |
| Standard | Base + rules | $18.25 + $4.38/rule | Production |
| **Application Gateway** |
| Standard_v2 | 10 CU | $317.60 | Basic Layer 7 LB |
| WAF_v2 | 10 CU + WAF | $381.78 | Web Application Firewall |
| **Azure Firewall** |
| Basic | Base + processing | $259 + $0.016/GB | Small deployments |
| Standard | Base + processing | $900 + $0.016/GB | Standard security |
| Premium | Base + processing | $1,260 + $0.016/GB | Advanced security |
| **VPN Gateway** |
| Basic | 100 Mbps | $27 | Basic connectivity |
| VpnGw1 | 650 Mbps | $142 | Standard production |
| VpnGw2 | 1 Gbps | $284 | High throughput |

---

## 💰 Cost per User Analysis

### Small Organization (25 users)
| Cost Category | Monthly Total | Cost per User | Annual per User |
|---------------|---------------|---------------|-----------------|
| Compute | $2,947 | $117.88 | $1,414.56 |
| Storage/Database | $1,166 | $46.64 | $559.68 |
| Networking | $428 | $17.12 | $205.44 |
| Security/Monitoring | $1,687 | $67.48 | $809.76 |
| **Total** | **$6,228** | **$249.12** | **$2,989.44** |

### Medium Organization (125 users)
| Cost Category | Monthly Total | Cost per User | Annual per User |
|---------------|---------------|---------------|-----------------|
| Compute | $18,438 | $147.50 | $1,770.00 |
| Storage/Database | $20,741 | $165.93 | $1,991.16 |
| Networking | $2,562 | $20.50 | $246.00 |
| Security/Monitoring | $9,133 | $73.06 | $876.72 |
| **Total** | **$50,874** | **$406.99** | **$4,883.88** |

### Large Enterprise (1,000 users)
| Cost Category | Monthly Total | Cost per User | Annual per User |
|---------------|---------------|---------------|-----------------|
| Compute | $127,800 | $127.80 | $1,533.60 |
| Storage/Database | $166,345 | $166.35 | $1,996.20 |
| Networking | $23,504 | $23.50 | $282.00 |
| Security/Monitoring | $54,510 | $54.51 | $654.12 |
| **Total** | **$372,159** | **$372.16** | **$4,465.92** |

---

## 🎯 Break-even Analysis for Optimization Strategies

### Reserved Instance Break-even Points

| VM SKU | PAYG Monthly | 1-Year RI Monthly | 3-Year RI Monthly | Break-even (Months) |
|--------|--------------|-------------------|-------------------|-------------------|
| Standard_D2s_v3 | $70.08 | $49.06 | $35.04 | 8.5 / 18 |
| Standard_D4s_v3 | $140.16 | $98.11 | $70.08 | 8.5 / 18 |
| Standard_D8s_v3 | $280.32 | $196.22 | $140.16 | 8.5 / 18 |
| Standard_E4s_v3 | $204.47 | $143.13 | $102.24 | 8.5 / 18 |

### Storage Tiering Break-even

| Scenario | Hot Storage Cost | Cool Storage Cost | Archive Cost | Break-even (Days) |
|----------|------------------|-------------------|--------------|-------------------|
| 1TB data accessed monthly | $21.28 | $15.36 + access fees | $1.02 + access fees | 30 / 90 |
| 1TB data accessed quarterly | $21.28 | $15.36 + access fees | $1.02 + access fees | 90 / 365 |
| 1TB data accessed annually | $21.28 | $15.36 + access fees | $1.02 + access fees | 365+ |

### Auto-shutdown Savings Calculator

| Environment Type | Hours Running | Monthly Savings vs 24/7 |
|------------------|---------------|------------------------|
| **Development** |
| Business hours (8×5) | 160 hours | 78% savings |
| Extended hours (12×5) | 240 hours | 67% savings |
| Business days (24×5) | 480 hours | 33% savings |
| **Testing** |
| Test cycles only | 100 hours | 86% savings |
| Continuous testing | 720 hours | 2% savings |
| **Staging** |
| Pre-release testing | 300 hours | 59% savings |
| Always available | 720 hours | 2% savings |

---

## 📊 Regional Cost Variations

### Top 5 Cheapest Azure Regions (Relative to East US)

| Region | Cost Multiplier | Example: D4s_v3 Monthly |
|--------|-----------------|------------------------|
| East US | 1.00x | $140.16 |
| South Central US | 1.00x | $140.16 |
| West US 2 | 1.04x | $145.77 |
| North Central US | 1.05x | $147.17 |
| Central US | 1.07x | $149.97 |

### Most Expensive Regions (Relative to East US)

| Region | Cost Multiplier | Example: D4s_v3 Monthly |
|--------|-----------------|------------------------|
| Japan West | 1.26x | $176.60 |
| Australia East | 1.31x | $183.61 |
| Brazil South | 1.52x | $213.04 |
| UAE North | 1.58x | $221.45 |
| South Africa North | 1.73x | $242.48 |

### Data Transfer Costs by Region Pair

| Source → Destination | Cost per GB | Use Case |
|---------------------|-------------|----------|
| **Intra-Region** | $0.00 | Same region resources |
| **Cross-Region (US)** | $0.02 | US East → US West |
| **Cross-Continent** | $0.05-$0.08 | US → Europe |
| **Internet Egress** | $0.087 | To internet (first 100GB free) |

---

## 🏆 Best Value Configurations by Use Case

### Development Environment - Best Value
```
Total Monthly Cost: $405

Virtual Machines:
- 3x Standard_B2ms (Linux): $186/month
- High burst capacity for development workloads

Database:
- PostgreSQL Burstable B1ms: $18/month
- Auto-pause capability during idle times

Storage:
- General Purpose v2 with lifecycle policies: $2/month
- Automatic tiering to reduce costs

Compute Platform:
- AKS with 2x Standard_B2s nodes: $62/month
- Cluster auto-scaler enabled

Cost per Developer: $16.20/month (25 developers)
```

### Production Environment - Best Performance/Cost
```
Total Monthly Cost: $4,955 (Small Org)

Compute:
- AKS cluster with mixed node pools
- Standard_D4s_v3 for balanced performance
- Reserved instances for 30% savings

Database:
- Azure SQL Standard S4 with read replicas
- Automated backup and point-in-time recovery

Networking:
- Application Gateway Standard_v2
- VPN Gateway for hybrid connectivity

Security:
- Standard Key Vault with access policies
- Log Analytics with 90-day retention

Cost per Active User: $198/month (25 users)
```

### High-Availability Production - Enterprise
```
Total Monthly Cost: $315,004 (Large Enterprise)

Multi-Region Setup:
- Primary region: Full deployment
- Secondary region: Disaster recovery
- Cross-region replication enabled

Premium Services:
- Business Critical SQL databases
- Premium Key Vault with HSM
- Azure Firewall Premium
- DDoS Protection Standard

Monitoring & Compliance:
- Microsoft Sentinel for SIEM
- Comprehensive logging and auditing
- Advanced threat protection

Cost per User: $315/month (1,000 users)
```

---

## 💡 Cost Optimization Quick Reference

### Immediate Cost Reducers (Week 1)
| Action | Potential Savings | Implementation |
|--------|------------------|----------------|
| Auto-shutdown dev/test | 40-60% | Azure Policy |
| Storage lifecycle policies | 40-80% | ARM template |
| Basic monitoring optimization | 20-40% | Log Analytics configuration |
| Remove unused public IPs | $3.65 each | Azure cleanup script |

### Medium-term Optimizations (Month 1-2)
| Action | Potential Savings | Implementation |
|--------|------------------|----------------|
| Reserved instances | 30-60% | Azure portal purchase |
| Right-size resources | 20-40% | Monitoring analysis |
| Consolidate services | 15-25% | Architecture review |
| CDN implementation | 20-30% networking | Azure Front Door |

### Strategic Changes (Month 2-6)
| Action | Potential Savings | Implementation |
|--------|------------------|----------------|
| Architecture optimization | 15-30% | Expert consultation |
| Service tier adjustments | 10-20% | Policy automation |
| Advanced monitoring | 5-15% | Custom dashboards |
| Governance automation | Ongoing 5-10% | Azure Policy suite |

---

*This cost comparison matrix is based on East US pricing as of 2024. Actual costs may vary based on specific usage patterns, enterprise agreements, and regional variations. Always validate pricing with the Azure Pricing Calculator for your specific scenario.*