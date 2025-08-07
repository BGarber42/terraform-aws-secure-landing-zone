# Terraform AWS Secure Landing Zone

A production-ready Terraform module for creating a secure AWS landing zone with comprehensive security, monitoring, and governance features.

## Overview

This module provides a complete foundation for AWS account security and compliance, including:

- **VPC with public/private subnets** across multiple availability zones
- **CloudTrail logging** with centralized S3 storage and optional KMS encryption
- **AWS Config** with managed rules for compliance monitoring
- **IAM baseline roles** with least-privilege access
- **GuardDuty** threat detection
- **Budget monitoring** with cost alerts
- **Security Hub** centralized security findings and compliance standards
- **Macie** data classification and privacy protection
- **Advanced security features** (S3 Block Public Access, custom compliance rules)

## Quick Start

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  cloudtrail_bucket_name = "my-org-cloudtrail-logs"
  
  tags = {
    Environment = "production"
    Owner       = "platform-team"
  }
}
```

## Features

| Component | Description | Resources |
|-----------|-------------|-----------|
| VPC | Multi-AZ VPC with public/private subnets, NAT Gateway, and Internet Gateway | `aws_vpc`, `aws_subnet`, `aws_internet_gateway`, `aws_nat_gateway` |
| CloudTrail | Centralized logging with S3 bucket, optional KMS encryption, lifecycle policies | `aws_cloudtrail`, `aws_s3_bucket`, `aws_kms_key` |
| AWS Config | Configuration recorder with managed rules for compliance | `aws_config_configuration_recorder`, `aws_config_rule` |
| IAM | Baseline roles with least-privilege access | `aws_iam_role`, `aws_iam_role_policy` |
| GuardDuty | Threat detection and monitoring | `aws_guardduty_detector` |
| Security Hub | Centralized security findings and compliance | `aws_securityhub_account`, `aws_securityhub_standards_subscription` |
| Macie | Data classification and privacy protection | `aws_macie2_account`, `aws_macie2_classification_job` |
| Budgets | Cost monitoring and alerting | `aws_budgets_budget` |

## Design Principles

- **Idempotent**: Safe to run multiple times without side effects
- **Extensible**: Modular design allows easy customization and extension
- **Secure-by-default**: Implements security best practices out of the box
- **Compliant**: Follows AWS Well-Architected Framework and security standards

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| aws | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account_id | AWS Account ID | `string` | n/a | yes |
| region | AWS region | `string` | `"us-east-1"` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| cloudtrail_bucket_arn | ARN of the CloudTrail S3 bucket |
| config_rule_arns | Map of Config rule names to ARNs |
| iam_role_arns | Map of IAM role names to ARNs |

## Examples

See the `examples/` directory for complete usage examples:

- `examples/basic/` - Minimal configuration with required variables only
- `examples/full/` - Complete configuration with all optional features enabled
- `examples/advanced/` - Advanced configuration with Security Hub and Macie features

## Development

### Git Workflow

This project uses a **linear history workflow** to maintain clean commit history and simplify release management. See [docs/git-workflow.md](docs/git-workflow.md) for detailed workflow documentation.

**Key Benefits:**
- Clean linear commit history
- No merge commit clutter
- Easy release management
- Proper Terraform Registry compatibility

**Quick Workflow:**
1. Create feature branch from `develop`
2. Make changes and create PR to `develop`
3. Merge with rebase to maintain linear history
4. When ready for release, fast-forward merge `develop` → `main`
5. Tag and release from `main`

### Testing

Run the Terratest suite locally:

```bash
cd test
go test -timeout 30m
```

### GitHub Actions Testing

Run GitHub Actions locally using [act](https://github.com/nektos/act):

```bash
# Setup secrets
cp .secrets.example .secrets
# Edit .secrets with your AWS credentials

# Run all tests
act --secret-file .secrets -W .github/workflows/ci.yml

# Run specific jobs
act --secret-file .secrets -W .github/workflows/ci.yml validate
act --secret-file .secrets -W .github/workflows/ci.yml test
```

See [docs/local-testing.md](docs/local-testing.md) for detailed instructions.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `terraform fmt` and `tflint`
5. Add tests for new functionality
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Keywords

AWS Control Tower, Landing Zone, Cloud Governance, IAM, Terraform Registry, Infrastructure as Code, Security, Compliance, Monitoring, Cost Management 