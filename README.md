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
  
  # Set to false for testing environments
  prevent_destroy = false
  
  # VPC Configuration (CIDRs calculated automatically)
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_count  = 2  # Creates 10.0.1.0/24, 10.0.2.0/24
  private_subnet_count = 2  # Creates 10.0.3.0/24, 10.0.4.0/24
  
  cloudtrail_bucket_name = "my-org-cloudtrail-logs"
  
  tags = {
    Environment = "production"
    Owner       = "platform-team"
  }
}
```

### Using OpenTofu

This module is fully compatible with OpenTofu. Simply replace `terraform` commands with `tofu`:

```bash
# Initialize with OpenTofu
tofu init

# Plan with OpenTofu
tofu plan

# Apply with OpenTofu
tofu apply
```

## Important Notes

### Resources with `prevent_destroy` Protection

Some resources in this module have `lifecycle.prevent_destroy` enabled by default to prevent accidental deletion of critical infrastructure:

- **S3 Buckets**: CloudTrail and GuardDuty S3 buckets are protected from accidental deletion
- **KMS Keys**: Encryption keys are protected to prevent data loss

#### Configurable Protection

The `prevent_destroy` variable allows you to control this protection:

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  # Set to false for testing environments
  prevent_destroy = false
  
  cloudtrail_bucket_name = "my-org-cloudtrail-logs"
  
  tags = {
    Environment = "production"
    Owner       = "platform-team"
  }
}
```

- **Production**: `prevent_destroy = true` (default) - Protects critical resources
- **Testing**: `prevent_destroy = false` - Allows complete cleanup for testing

#### Manual Cleanup (when prevent_destroy = true)

When `prevent_destroy = true`, these protected resources must be manually deleted:

```bash
# After running terraform destroy, manually delete S3 buckets:
aws s3 rb s3://your-cloudtrail-bucket-name --force
aws s3 rb s3://your-guardduty-bucket-name --force
```

#### Test Deployment

For test deployments with `prevent_destroy = false`, you can use standard Terraform commands:

```bash
# Deploy test infrastructure
terraform apply

# Clean up test infrastructure
terraform destroy
```

This approach allows complete cleanup including protected resources when `prevent_destroy = false`.

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
| terraform | >= 1.5.0 |
| aws | >= 6.0.0 |

**Note:** This module is also compatible with OpenTofu >= 1.5.0. OpenTofu is a Terraform fork that maintains full compatibility with Terraform modules and providers.

## Providers

| Name | Version |
|------|---------|
| aws | >= 6.0.0 |

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

## Advanced Features

### Macie Custom Data Identifiers

Configure custom data identifiers for sensitive data detection:

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  enable_macie = true
  macie_custom_data_identifiers = {
    "credit_card_pattern" = {
      description  = "Credit card number pattern"
      regex        = "\\b\\d{4}[- ]?\\d{4}[- ]?\\d{4}[- ]?\\d{4}\\b"
      keywords     = ["credit", "card", "payment"]
      ignore_words = ["test", "example", "sample"]
    },
    "ssn_pattern" = {
      description  = "Social Security Number pattern"
      regex        = "\\b\\d{3}-\\d{2}-\\d{4}\\b"
      keywords     = ["ssn", "social", "security"]
      ignore_words = ["test", "example"]
    }
  }
}
```

### Security Hub Action Targets

Configure Security Hub action targets for automated responses:

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  enable_security_hub   = true
  enable_action_targets = true
  enable_cis_standard   = true
  enable_pci_standard   = false
}
```

### Budget Actions

Configure automated budget actions for cost control:

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  enable_budget_alerts     = true
  enable_budget_actions    = true
  budget_limit_usd         = 1000
  budget_alert_subscribers = ["admin@example.com", "finance@example.com"]
}
```

### Dynamic CIDR Calculation

The module automatically calculates subnet CIDRs using Terraform's `cidrsubnet` function:

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  # VPC Configuration with automatic CIDR calculation
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_count  = 3  # Creates 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
  private_subnet_count = 3  # Creates 10.0.4.0/24, 10.0.5.0/24, 10.0.6.0/24
  
  # Optional: Override with custom CIDRs
  # public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  # private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
}
```

**Benefits:**
- **Automatic Calculation**: No need to manually calculate CIDR blocks
- **Flexible Scaling**: Easily add more subnets without CIDR conflicts
- **Validation**: Built-in validation prevents overlapping CIDRs
- **Backward Compatible**: Still supports custom CIDR specification

### Resource Protection with `prevent_destroy`

The module includes built-in protection for critical resources:

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  # Protect critical resources from accidental deletion
  prevent_destroy = true  # Default: true for production
  
  # For testing environments, set to false for complete cleanup
  # prevent_destroy = false
}
```

**Protected Resources:**
- S3 buckets (CloudTrail logs, GuardDuty findings)
- KMS keys (encryption keys)
- IAM roles and policies

**Manual Cleanup (when `prevent_destroy = true`):**
```bash
# After terraform destroy, manually delete protected resources:
aws s3 rb s3://your-cloudtrail-bucket-name --force
aws s3 rb s3://your-guardduty-bucket-name --force
```

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