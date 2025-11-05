# Cloud Infrastructure Framework - Azure CAF & AWS Well-Architected

This repository contains enterprise-grade Terraform infrastructure frameworks for both Microsoft Azure and Amazon Web Services, providing comprehensive, secure-by-default cloud infrastructure patterns.

## 🏗️ Repository Structure

```
├── Azure-CAF/                     # Microsoft Azure Cloud Adoption Framework
│   ├── README.md                  # Azure CAF documentation
│   ├── modules/                   # 446+ Azure service modules
│   ├── examples/                  # Azure deployment examples
│   ├── *.tf                      # 55,657+ lines of Azure Terraform code
│   └── documentation/            # Comprehensive Azure guides
│
├── AWS-WellArchitected/           # AWS Well-Architected Framework
│   ├── README.md                  # AWS framework documentation
│   ├── modules/                   # AWS Well-Architected pillar modules
│   ├── examples/                  # AWS deployment examples
│   ├── aws_*.tf                  # AWS framework core files
│   └── pillars/                   # 6 Well-Architected pillars
│
├── .github/                       # GitHub Actions workflows
├── .devcontainer/                 # Development environment
└── LICENSE                        # MIT License
```

---

## 🔷 Azure Cloud Adoption Framework (CAF)

**Location**: `./Azure-CAF/`

### Overview
The Azure CAF module provides comprehensive infrastructure-as-code for Microsoft Azure, covering 100+ service types with enterprise-grade patterns and security best practices.

### Key Features
- **Comprehensive Coverage**: 1,883 Terraform files covering all major Azure services
- **Enterprise Ready**: Multi-subscription, multi-region support
- **Security Hardened**: Secure-by-default configurations with recent security improvements
- **Well Documented**: Extensive examples and documentation

### Recent Security Improvements ✅
- **Key Vault**: Public network access defaults to `false` (was `null`)
- **Storage Accounts**: Public network access defaults to `false` (was `null`)
- **PostgreSQL**: TLS enforcement defaults to `TLS1_2` (was disabled)
- **MySQL**: TLS enforcement defaults to `TLS1_2` (was disabled)
- **SQL Server**: Azure AD authentication defaults to `true` (was `false`)
- **CORS**: Added security warnings for wildcard origins

### Quick Start - Azure
```bash
cd Azure-CAF
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings
terraform init
terraform plan
terraform apply
```

---

## ☁️ AWS Well-Architected Framework

**Location**: `./AWS-WellArchitected/`

### Overview
The AWS Well-Architected Framework module implements all six pillars of AWS best practices in a comprehensive, enterprise-ready Terraform module.

### Six Pillars Implementation

#### 1. **Operational Excellence** 🔧
- **CloudWatch**: Comprehensive monitoring and dashboards
- **CloudTrail**: API logging and compliance tracking
- **X-Ray**: Distributed tracing for applications
- **Config**: Configuration compliance monitoring
- **Systems Manager**: Automated operational tasks

#### 2. **Security** 🛡️
- **KMS**: Key management with automatic rotation
- **Secrets Manager**: Secure credential storage
- **GuardDuty**: Threat detection with ML
- **Security Hub**: Centralized security findings
- **WAF**: Web application firewall protection
- **IAM**: Strict password policies and least privilege

#### 3. **Reliability** 🏛️
- **Multi-AZ**: High availability by default
- **Auto Scaling**: Automatic capacity management
- **Load Balancers**: Application and network load balancing
- **Backup**: Automated backup strategies
- **Disaster Recovery**: Cross-region replication

#### 4. **Performance Efficiency** ⚡
- **CloudFront**: Global content delivery
- **Lambda**: Serverless compute optimization
- **EC2**: Right-sizing and optimization
- **S3**: Storage performance optimization
- **Caching**: ElastiCache integration

#### 5. **Cost Optimization** 💰
- **Budgets**: Automated spend monitoring
- **Cost Explorer**: Detailed cost analysis
- **Reserved Instances**: Capacity planning
- **Spot Instances**: Cost-effective compute
- **Resource Lifecycle**: Automated cleanup

#### 6. **Sustainability** 🌱
- **Carbon Footprint**: Environmental impact tracking
- **Right Sizing**: Resource efficiency optimization
- **Renewable Energy**: Region selection preferences
- **Graviton**: ARM-based processors support

### Architecture Highlights
- **Secure by Default**: All services configured with enterprise security
- **Multi-Region Ready**: Built for global deployments
- **Cost Optimized**: Intelligent resource management
- **Environment Aware**: Dev/staging/production configurations

### Quick Start - AWS
```bash
cd AWS-WellArchitected
cp examples/complete-deployment/terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings
terraform init
terraform plan
terraform apply
```

---

## 🚀 Quick Comparison

| Feature | Azure CAF | AWS Well-Architected |
|---------|-----------|---------------------|
| **Service Coverage** | 100+ Azure services | 6 comprehensive pillars |
| **Files** | 1,883 Terraform files | 16 core files + modules |
| **Lines of Code** | 55,657 lines | 3,790 lines |
| **Security** | Recently hardened | Secure-by-default |
| **Enterprise Ready** | ✅ Full featured | ✅ Enterprise patterns |
| **Multi-Region** | ✅ Supported | ✅ Built-in |
| **Examples** | 60+ examples | Production-ready templates |

---

## 🛡️ Security Features

### Both Frameworks Include:
- **Encryption**: At rest and in transit by default
- **Network Security**: Multi-layer protection (NSGs/Security Groups)
- **Identity Management**: Azure AD / AWS IAM integration
- **Monitoring**: Comprehensive logging and alerting
- **Compliance**: Industry standard compliance patterns
- **Threat Detection**: AI-powered security monitoring

### Security Best Practices:
- Private subnets for applications and databases
- No public IPs assigned by default
- Strong password policies enforced
- Multi-factor authentication support
- Least privilege access patterns
- Automated security scanning

---

## 📖 Documentation

### Azure CAF Documentation
- [Azure CAF README](./Azure-CAF/README.md) - Comprehensive Azure documentation
- [Azure Examples](./Azure-CAF/examples/) - 60+ deployment examples
- [Azure Modules](./Azure-CAF/modules/) - 446 service-specific modules

### AWS Documentation
- [AWS Framework README](./AWS-WellArchitected/README.md) - AWS Well-Architected guide
- [AWS Examples](./AWS-WellArchitected/examples/) - Production deployment templates
- [AWS Modules](./AWS-WellArchitected/modules/) - Pillar-based module organization

---

## 🤝 Contributing

We welcome contributions to both frameworks! Please see our contribution guidelines:

1. **Fork** the repository
2. **Create** a feature branch
3. **Make** your changes following the established patterns
4. **Test** your changes thoroughly
5. **Submit** a pull request

### Development Environment
A complete development environment is provided via:
- **Dev Container**: `.devcontainer/` for consistent development
- **GitHub Actions**: Automated testing and validation
- **Pre-commit Hooks**: Code quality enforcement

---

## 📊 Performance & Scale

### Azure CAF
- **Enterprise Scale**: Supports massive Azure deployments
- **Battle Tested**: Used in production by Microsoft customers
- **Comprehensive**: 100% Azure service coverage
- **Mature**: Years of development and refinement

### AWS Well-Architected
- **Optimized**: Built for efficiency and performance
- **Modern**: Latest AWS services and features
- **Scalable**: Designed for global enterprise deployments
- **Compliant**: Follows all AWS best practices

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🆘 Support

For support and questions:

- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for community support
- **Documentation**: Comprehensive docs in each framework folder

---

## 🏆 Recognition

- **Azure CAF**: Official Microsoft-supported framework
- **AWS Well-Architected**: Follows official AWS architectural guidelines
- **Security Hardened**: Recently improved with enterprise security defaults
- **Production Ready**: Both frameworks ready for enterprise deployment

---

**Choose the right framework for your cloud journey:**
- **Azure CAF**: For comprehensive Azure infrastructure deployments
- **AWS Well-Architected**: For modern, pillar-based AWS architectures

Both provide enterprise-grade, secure-by-default cloud infrastructure patterns ready for production use! 🚀