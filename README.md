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

## Quick Start

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  # VPC Configuration with automatic CIDR calculation
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
tofu init
tofu plan
tofu apply
```

## Important Notes

### Resource Protection

Some resources have `lifecycle.prevent_destroy` enabled by default. Set `prevent_destroy = false` for testing environments:

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  prevent_destroy = false  # For testing environments
  
  cloudtrail_bucket_name = "my-org-cloudtrail-logs"
}
```

When `prevent_destroy = true`, manually delete protected S3 buckets after `terraform destroy`:

```bash
aws s3 rb s3://your-cloudtrail-bucket-name --force
aws s3 rb s3://your-guardduty-bucket-name --force
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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 6.0.0 |

**Note:** This module is also compatible with OpenTofu >= 1.5.0.

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