# Networking Services - Cost Analysis

## Overview
Networking services typically represent 15-25% of total Azure infrastructure costs. These costs include connectivity, security, and data transfer charges that can quickly accumulate at scale.

---

## 🌐 Virtual Networks & Core Networking

### Configuration Options (from `networking.tf`)
- Virtual Networks (VNets) with multiple subnets
- Network Security Groups (NSGs)
- Route tables and custom routing
- VNet peering (local and global)
- Service endpoints and private endpoints

### Cost Structure
| Component | Cost | Notes |
|-----------|------|-------|
| **Virtual Network** | FREE | No charge for VNet itself |
| **Subnets** | FREE | No additional cost |
| **NSG Rules** | FREE | First 100 rules per NSG |
| **Route Tables** | FREE | Basic routing included |
| **Public IP (Basic)** | FREE | While associated with resource |
| **Public IP (Standard)** | $3.65/month | Static allocation |
| **VNet Peering (Local)** | $0.01/GB transferred | Same region |
| **VNet Peering (Global)** | $0.035/GB transferred | Cross-region |

### Example VNet Costs

#### **Basic Hub-Spoke Architecture**
```
Hub VNet: FREE
- 3 Spoke VNets: FREE
- NSGs: FREE (under 100 rules)
- Route Tables: FREE
- Public IPs: 5 × $3.65 = $18.25/month
Local VNet Peering: ~$50-200/month (data dependent)
Total Base: ~$70-220/month
```

#### **Multi-Region Setup**
```
Primary Region VNet: FREE
Secondary Region VNet: FREE
Global VNet Peering: $0.035/GB
- Typical 100GB/month = $3.50
- High traffic 1TB/month = $35
- Enterprise 10TB/month = $350
```

---

## 🔥 Azure Firewall

### Configuration (from `azurerm_firewalls.tf`, `azurerm_firewall_policies.tf`)
- Standard and Premium tiers
- Forced tunneling support
- DNS proxy capabilities
- Threat intelligence integration

### Pricing Structure

#### **Azure Firewall Standard**
```
Base Cost: $1.25/hour = $900/month
Data Processing: $0.016/GB

Example Monthly Costs:
- Small org (100GB/month): $900 + $1.60 = $901.60
- Medium org (1TB/month): $900 + $16 = $916
- Large org (10TB/month): $900 + $160 = $1,060
```

#### **Azure Firewall Premium**
```
Base Cost: $1.75/hour = $1,260/month
Data Processing: $0.016/GB
Additional Features:
- TLS inspection
- IDPS (Intrusion Detection/Prevention)
- URL filtering
- Web categories

Example Monthly Costs:
- Small org: $1,260 + processing = ~$1,275
- Medium org: $1,260 + processing = ~$1,276
- Large org: $1,260 + processing = ~$1,420
```

#### **Azure Firewall Basic** (Preview)
```
Base Cost: $0.36/hour = $259/month
Data Processing: $0.016/GB
Limited Features: Basic filtering only
Target: Small deployments, SMBs
```

### Firewall Cost Optimization
- ✅ Use **Basic tier** for simple filtering requirements
- ✅ Consider **third-party NVAs** for cost-sensitive scenarios
- ✅ Implement **traffic optimization** to reduce data processing charges
- ✅ Use **NSGs** for basic filtering before firewall
- ❌ Avoid Premium tier unless advanced security features are required

---

## ⚖️ Load Balancers

### Configuration (from `load_balancers.tf`)
- Standard Load Balancer (Layer 4)
- Application Gateway (Layer 7)
- Multiple backend pools and health probes
- NAT rules and outbound rules

### Azure Load Balancer (Layer 4)

#### **Basic Load Balancer**
```
Cost: FREE
Limitations:
- No SLA
- Open by default (no NSG)
- Backend pool limited to single availability set
- No outbound rules
Usage: Development environments only
```

#### **Standard Load Balancer**
```
Base Cost: $18.25/month
Rules: $4.38/month per rule (first 5 free)
Data Processing: $0.005/GB

Example Configurations:
Basic Setup (5 rules): $18.25/month
Complex Setup (20 rules): $18.25 + (15 × $4.38) = $83.95/month
High Traffic (1TB/month): $18.25 + $5 = $23.25/month
```

### Application Gateway (Layer 7)

#### **Standard_v2 SKU**
```
Fixed Cost: $0.36/hour = $259.20/month
Capacity Units (CU): $0.008/hour per CU
Data Processing: $0.008/GB

Example Configurations:
Small (10 CU): $259.20 + (10 × $0.008 × 730) = $317.60/month
Medium (50 CU): $259.20 + (50 × $0.008 × 730) = $551.20/month
Large (125 CU): $259.20 + (125 × $0.008 × 730) = $988.20/month
```

#### **WAF_v2 SKU**
```
Fixed Cost: $0.443/hour = $323.38/month
Capacity Units: $0.008/hour per CU
Additional WAF Rules: $1 per custom rule

Example with WAF:
Medium + WAF (50 CU, 20 rules): $551.20 + $64.18 + $20 = $635.38/month
```

---

## 🔒 VPN & ExpressRoute

### VPN Gateway
Configuration from `virtual_network_gateways.tf`:

#### **VPN Gateway SKUs**
```
Basic: $27/month (100 Mbps, 10 tunnels)
VpnGw1: $142/month (650 Mbps, 30 tunnels)
VpnGw2: $284/month (1 Gbps, 30 tunnels)
VpnGw3: $568/month (1.25 Gbps, 30 tunnels)
VpnGw4: $730/month (5 Gbps, 100 tunnels)
VpnGw5: $1,460/month (10 Gbps, 100 tunnels)

Additional Costs:
- Local Network Gateway: FREE
- Connection: FREE
- Data Transfer: Standard rates apply
```

### ExpressRoute
Configuration from `express_route_*.tf`:

#### **ExpressRoute Circuit Pricing**
```
50 Mbps: $55/month (Metered) or $181/month (Unlimited)
100 Mbps: $105/month (Metered) or $261/month (Unlimited)
200 Mbps: $210/month (Metered) or $522/month (Unlimited)
500 Mbps: $525/month (Metered) or $1,305/month (Unlimited)
1 Gbps: $1,050/month (Metered) or $2,610/month (Unlimited)
2 Gbps: $2,100/month (Metered) or $5,220/month (Unlimited)
5 Gbps: $5,250/month (Metered) or $13,050/month (Unlimited)
10 Gbps: $10,500/month (Metered) or $26,100/month (Unlimited)

Additional Costs:
- ExpressRoute Gateway: $142-568/month (based on SKU)
- Data Transfer: $0.025/GB outbound (inbound free)
- Partner/Telco Circuit: Varies by provider
```

---

## 🌍 Content Delivery Network (CDN)

### Configuration (from `cdn_profile.tf`)
- Microsoft CDN
- Verizon Standard/Premium
- Akamai Standard
- Custom origins and caching rules

### CDN Pricing

#### **Microsoft CDN**
```
First 10TB: $0.087/GB
Next 40TB: $0.065/GB
Next 100TB: $0.043/GB
Over 150TB: $0.025/GB

HTTPS Requests: $0.0075 per 10,000 requests

Example Costs:
1TB/month: ~$89
5TB/month: ~$378
50TB/month: ~$2,890
```

#### **Verizon Premium** (Advanced Features)
```
First 10TB: $0.18/GB
Additional features:
- Real-time analytics
- Advanced caching rules
- Token authentication

Example: 10TB = $1,800/month
```

---

## 🛡️ DDoS Protection

### Configuration (from `ddos_services.tf`)
- DDoS Protection Standard
- Always-on monitoring
- Attack mitigation and reporting

### DDoS Protection Pricing
```
DDoS Protection Standard: $2,944/month (flat fee)
Covers: Up to 100 resources per subscription
Overage: $29.44/month per additional resource

Cost Analysis:
- 1-10 resources: $2,944/month ($294+ per resource)
- 50 resources: $2,944/month ($59 per resource)
- 100 resources: $2,944/month ($29 per resource)
- 150 resources: $2,944 + $1,472 = $4,416/month
```

**Recommendation**: Only enable for high-value production workloads or when required by compliance.

---

## 🏠 Private DNS & Networking Security

### Private DNS Zones
Configuration from `private_dns*.tf`:

```
Private DNS Zone: $0.50/month per zone
DNS Queries: $0.40 per million queries

Example:
5 zones, 1M queries/month: (5 × $0.50) + $0.40 = $2.90/month
```

### Network Watcher
```
Network Watcher: FREE (enabled by default)
Flow Logs Storage: Standard storage rates
Traffic Analytics: $0.50/GB processed
Connection Monitor: $0.80/month per endpoint
```

---

## 📊 Data Transfer Costs

### Inbound Data Transfer
```
All inbound data transfer: FREE
Exception: Data transfer via ExpressRoute has partner charges
```

### Outbound Data Transfer

#### **Internet Egress**
```
First 100GB/month: FREE
Next 9.9TB: $0.087/GB
Next 40TB: $0.083/GB
Next 100TB: $0.07/GB
Over 150TB: $0.05/GB
```

#### **Inter-Region Transfer**
```
Same Region: FREE
Cross-Region (within continent): $0.02/GB
Cross-Continent: $0.05-0.08/GB (varies by destination)
```

#### **Example Data Transfer Costs**
```
Small Organization (500GB/month internet):
- 100GB free + 400GB × $0.087 = $34.80/month

Medium Organization (5TB/month mixed):
- Internet: $378/month
- Inter-region: $50-100/month
- Total: ~$428-478/month

Large Enterprise (50TB/month):
- Internet egress: ~$2,890/month
- Inter-region: $500-1,000/month
- ExpressRoute: $200-500/month
- Total: ~$3,590-4,390/month
```

---

## 🎯 Networking Cost Optimization Strategies

### 1. Optimize Data Transfer
- ✅ Use **CDN** for static content (reduces origin bandwidth)
- ✅ Implement **caching** strategies at multiple layers
- ✅ **Co-locate services** in same region when possible
- ✅ Use **VNet peering** instead of VPN for Azure-to-Azure connectivity

### 2. Right-Size Network Components
- ✅ Start with **Basic Load Balancer** for development
- ✅ Use **Standard Load Balancer** only when SLA is required
- ✅ Evaluate **third-party firewalls** vs Azure Firewall for cost
- ✅ Choose appropriate **VPN Gateway SKU** based on throughput needs

### 3. Traffic Optimization
- ✅ Implement **traffic shaping** and **QoS** policies
- ✅ Use **Application Gateway** path-based routing to consolidate services
- ✅ Enable **Connection Draining** to avoid unnecessary charges
- ✅ Configure **auto-scaling** rules to match demand

### 4. Architectural Decisions
- ✅ Consider **Hub-Spoke** vs **Mesh** topology costs
- ✅ Evaluate **ExpressRoute** vs **Site-to-Site VPN** based on bandwidth needs
- ✅ Use **Service Endpoints** instead of Private Endpoints where possible
- ✅ Implement **Private Link** strategically for security requirements

---

## 📊 Networking Cost Summary by Environment

### Small Organization (10-50 employees)
| Component | Dev | Staging | Production | Monthly Total |
|-----------|-----|---------|------------|---------------|
| **Basic Networking** | $20 | $30 | $50 | $100 |
| **Load Balancing** | $0 | $20 | $85 | $105 |
| **VPN/Connectivity** | $0 | $0 | $142 | $142 |
| **Data Transfer** | $10 | $20 | $100 | $130 |
| **Total** | **$30** | **$70** | **$377** | **$477** |

### Medium Organization (50-200 employees)
| Component | Dev | Staging | Production | Monthly Total |
|-----------|-----|---------|------------|---------------|
| **Basic Networking** | $50 | $75 | $150 | $275 |
| **Load Balancing** | $20 | $85 | $320 | $425 |
| **Firewall** | $0 | $0 | $950 | $950 |
| **VPN/ExpressRoute** | $0 | $0 | $600 | $600 |
| **Data Transfer** | $50 | $100 | $500 | $650 |
| **Total** | **$120** | **$260** | **$2,520** | **$2,900** |

### Large Enterprise (200+ employees)
| Component | Dev | Staging | Production | Monthly Total |
|-----------|-----|---------|------------|---------------|
| **Basic Networking** | $100 | $200 | $500 | $800 |
| **Load Balancing** | $85 | $320 | $1,000 | $1,405 |
| **Firewall Premium** | $0 | $1,260 | $1,420 | $2,680 |
| **ExpressRoute** | $0 | $0 | $2,600 | $2,600 |
| **DDoS Protection** | $0 | $0 | $2,944 | $2,944 |
| **Data Transfer** | $200 | $500 | $2,000 | $2,700 |
| **CDN** | $0 | $0 | $500 | $500 |
| **Total** | **$385** | **$2,280** | **$10,964** | **$13,629** |

---

## ⚠️ Hidden Networking Costs to Watch

1. **Idle Public IP Addresses**: $3.65/month each when not associated
2. **Excessive Load Balancer Rules**: $4.38/month per rule after first 5
3. **Cross-Region Data Transfer**: $0.02-0.08/GB can add up quickly
4. **DDoS Protection Underutilization**: $2,944/month for < 20 resources is expensive
5. **Firewall Premium Overuse**: $360/month premium over standard for features you may not need
6. **ExpressRoute Metered Overage**: High data transfer costs on metered plans
7. **Application Gateway Overprovisioning**: Capacity Units scale automatically
8. **VPN Gateway Oversizing**: Higher SKUs for bandwidth you don't use

---

## 🔗 Networking Dependencies & Integration Costs

### Storage Account Private Endpoints
```
Private Endpoint: $7.30/month per endpoint
DNS Resolution: Included in Private DNS zone costs
Bandwidth: Standard transfer rates apply
```

### AKS Networking Add-ons
```
Standard Load Balancer: $18.25/month (automatic)
Application Gateway Ingress: $259.20+ /month (optional)
Private Cluster API: Included in AKS
```

### Database Private Connectivity
```
SQL DB Private Endpoint: $7.30/month
Cosmos DB Private Endpoint: $7.30/month
MySQL/PostgreSQL: $7.30/month each
```

---

*This analysis is based on East US pricing as of 2024. Networking costs can vary significantly based on traffic patterns, architectural decisions, and data transfer volumes. Always validate with the Azure Pricing Calculator for your specific scenario.*