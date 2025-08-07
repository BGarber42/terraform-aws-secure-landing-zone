# Local Testing Guide

This guide helps you test the Terraform AWS Landing Zone module locally.

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.12.2
- PowerShell (for Windows) or Bash shell (for Linux/Mac)

## Quick Test Setup

1. **Create a test deployment directory:**
   ```bash
   mkdir test-deployment-test
   cd test-deployment-test
   ```

2. **Create main.tf that references the module:**
   ```hcl
   terraform {
     required_version = ">= 1.12.2"
     
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = ">= 5.0.0"
       }
     }
   }

   provider "aws" {
     region = "us-east-1"
   }

   module "landing_zone" {
     source = "../"

     account_id = "YOUR_ACCOUNT_ID"
     region     = "us-east-1"
     
     cloudtrail_bucket_name = "test-landing-zone-cloudtrail-YOUR_ACCOUNT_ID"
     guardduty_findings_bucket_name = "test-landing-zone-guardduty-YOUR_ACCOUNT_ID"
     
     # Set prevent_destroy to false for test deployments
     prevent_destroy = false
     
     tags = {
       Environment = "test"
       Owner       = "test-deployment"
       Purpose     = "module-validation"
     }
   }

   output "vpc_id" {
     description = "The ID of the VPC"
     value       = module.landing_zone.vpc_id
   }

   output "cloudtrail_bucket_arn" {
     description = "ARN of the CloudTrail S3 bucket"
     value       = module.landing_zone.cloudtrail_bucket_arn
   }
   ```

3. **Deploy the test infrastructure:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Clean up after testing:**
   ```bash
   terraform destroy
   ```

## Important: Resources with `prevent_destroy` Protection

Some resources in this module have `lifecycle.prevent_destroy` enabled by default to prevent accidental deletion:

### Protected Resources
- **S3 Buckets**: CloudTrail and GuardDuty buckets are protected
- **KMS Keys**: Encryption keys are protected

### Configurable Protection

The `prevent_destroy` variable allows you to control this protection:

- **Production**: `prevent_destroy = true` (default) - Protects critical resources
- **Testing**: `prevent_destroy = false` - Allows complete cleanup for testing

### Test Configuration

For test deployments, ensure your `main.tf` includes:

```hcl
module "landing_zone" {
  # ... other configuration ...
  
  # Set prevent_destroy to false for test deployments
  prevent_destroy = false
  
  # ... other configuration ...
}
```

### Manual Cleanup (when prevent_destroy = true)

When `prevent_destroy = true`, these protected resources must be manually deleted:

```bash
# After terraform destroy, manually delete S3 buckets:
aws s3 rb s3://test-cloudtrail-logs-1234567890 --force
aws s3 rb s3://test-guardduty-findings-1234567890 --force
```

### Automated Cleanup

For test deployments with `prevent_destroy = false`, you can use standard Terraform commands:

```bash
# Deploy test infrastructure
terraform apply

# Clean up test infrastructure
terraform destroy
```

This approach allows complete cleanup including protected resources when `prevent_destroy = false`.

## Test Configuration

The test deployment uses the following configuration:

- **Account ID**: Your AWS account ID
- **Region**: us-east-1
- **VPC CIDR**: 10.0.0.0/16
- **Subnets**: 2 public, 2 private across 2 AZs
- **Security Services**: CloudTrail, Config, GuardDuty, Budget alerts
- **IAM Roles**: ReadOnlyAdmin, PowerUserRestrictedIAM
- **prevent_destroy**: false (for testing)

## Troubleshooting

### Common Issues

1. **AWS CLI not configured:**
   ```bash
   aws configure
   ```

2. **Insufficient permissions:**
   - Ensure your AWS user/role has the necessary permissions
   - Check IAM policies for required actions

3. **S3 bucket already exists:**
   - Use unique bucket names in your configuration
   - Or manually delete existing buckets first

4. **KMS key creation fails:**
   - Check KMS service quotas
   - Ensure proper IAM permissions for KMS

### Cleanup Issues

If `terraform destroy` fails due to protected resources:

1. **Check prevent_destroy setting:**
   ```bash
   # Ensure your main.tf has:
   prevent_destroy = false
   ```

2. **Manual cleanup:**
   ```bash
   # Delete S3 buckets manually
   aws s3 rb s3://bucket-name --force
   
   # Delete KMS keys manually (if needed)
   aws kms schedule-key-deletion --key-id key-id --pending-window-in-days 7
   ```

## Security Considerations

- Test deployments use predictable resource names
- S3 buckets contain test data only
- KMS keys are created with 7-day deletion window
- All resources are tagged for easy identification

## Cost Optimization

- Test deployments use minimal configurations
- Budget alerts are set to $100 USD
- Resources are designed for quick cleanup
- Consider using AWS Organizations for isolated testing
