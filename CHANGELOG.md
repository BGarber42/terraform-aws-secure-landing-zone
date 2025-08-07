# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Additional security features and compliance controls
- Enhanced monitoring and alerting capabilities
- Multi-region deployment support
- Advanced networking configurations

## [0.5.0] - 2025-08-07

### Added
- **Dynamic CIDR calculation** using Terraform's `cidrsubnet` function
- **Automatic subnet CIDR generation** based on VPC CIDR and subnet counts
- **New variables** `public_subnet_count` and `private_subnet_count` for easy scaling
- **Built-in validation** to prevent CIDR conflicts and VPC capacity issues
- **Backward compatibility** with existing custom CIDR specifications

### Changed
- **VPC module** now supports automatic CIDR calculation with fallback to custom CIDRs
- **Subnet creation** simplified with count-based configuration
- **Validation** updated to use modern `terraform_data` resource instead of deprecated `null_data_source`

### Technical Details
- **CIDR Calculation**: Uses `cidrsubnet(var.vpc_cidr, 8, index)` for /24 subnets
- **Validation**: Prevents overlapping CIDRs and validates against VPC capacity
- **Compatibility**: Works with both Terraform >= 1.5.0 and OpenTofu >= 1.5.0
- **Examples**: Updated all examples to demonstrate new dynamic CIDR approach

### Migration Guide
Existing configurations continue to work without changes. To use the new dynamic CIDR feature:

```hcl
# New approach with automatic CIDR calculation
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"
  
  account_id = "123456789012"
  region     = "us-east-1"
  
  # VPC Configuration with automatic CIDR calculation
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_count  = 3  # Creates 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
  private_subnet_count = 3  # Creates 10.0.4.0/24, 10.0.5.0/24, 10.0.6.0/24
}
```

## [0.4.4] - 2025-08-07

### Added
- **CHANGELOG date corrections** to match actual Git commit dates
- **Release cleanup** to remove outdated releases from GitHub

### Changed
- **Release dates** corrected to reflect actual commit history
- **Version consistency** maintained across all documentation

### Technical Details
- **Date Accuracy**: All release dates now match Git commit timestamps
- **Release Management**: Streamlined release process for future versions
- **Documentation**: Improved accuracy of project history

## [0.4.3] - 2025-08-07

### Added
- **OpenTofu compatibility** with full feature support
- **Version requirements optimization** from >= 1.12.2 to >= 1.5.0 for broader compatibility
- **OpenTofu usage documentation** with command examples
- **Comprehensive testing** of all examples with OpenTofu v1.10.5

### Changed
- **Version constraints** updated across all examples and root module
- **README documentation** enhanced with OpenTofu compatibility notes
- **Provider compatibility** verified with OpenTofu registry

### Technical Details
- **OpenTofu Testing**: All examples (basic, full, advanced) tested successfully
- **Feature Compatibility**: All advanced features work with OpenTofu including:
  - Macie custom data identifiers
  - Security Hub action targets and insights
  - Complex validation blocks
  - Dynamic blocks and for_each loops
- **Provider Integration**: OpenTofu automatically updates provider registry references
- **Performance**: OpenTofu often provides faster execution for large configurations

## [0.4.1] - 2025-08-07

### Added
- **Optimized Git workflow documentation** with clear release process instructions
- **Updated CI/CD workflow documentation** to reflect current GitHub Actions structure
- **GitHub rulesets optimization** for release branches and main branch flexibility
- **Release branch protection rules** for streamlined release process

### Changed
- **Documentation structure** improved with proper separation of committed vs uncommitted content
- **Main branch ruleset** now allows both merge and squash methods for flexibility
- **Release process documentation** updated to use standard git commands
- **Workflow documentation** moved script references to dedicated scripts folder

### Fixed
- **Documentation reliability** by removing references to uncommitted scripts
- **Release process clarity** with step-by-step manual git workflow
- **Branch protection rules** optimized for linear history workflow

### Technical Details
- **Main ruleset**: Added "squash" merge method alongside "merge" for flexibility
- **Release ruleset**: Created new ruleset for `release/*` branches with streamlined requirements
- **Documentation**: Moved script documentation to `scripts/README.md` for better organization
- **Workflow**: Maintained linear history while supporting both automated and manual release processes

## [0.3.0] - 2025-08-07

### Added
- **Configurable `prevent_destroy` variable** with dual-bucket approach for S3 resources
  - Default `prevent_destroy = true` for production safety
  - Option to set `prevent_destroy = false` for test environments
  - Conditional resource creation using `count` parameter
- **Plan-only validation mode** for test deployment script (`-PlanOnly` parameter)
- **Enhanced test deployment script** with improved error handling and validation
- **Security scanning disable comments** for CloudTrail and GuardDuty S3 buckets
  - Prevents false positive security alerts for service-specific buckets
- **Updated documentation** with comprehensive testing guide
- **Consolidated `.gitignore`** to ignore entire `scripts/` directory

### Changed
- **S3 bucket implementation** now uses dual-bucket approach:
  - `*_protected` buckets with `lifecycle.prevent_destroy = true`
  - `*_unprotected` buckets without lifecycle protection
  - Conditional selection based on `prevent_destroy` variable
- **Test deployment workflow** now supports plan-only mode for validation
- **Local testing guide** updated with manual setup instructions
- **README.md** enhanced with configurable `prevent_destroy` documentation

### Removed
- **Deprecated `setup-test-vars.sh`** script (replaced by improved test deployment)
- **References to non-committed scripts** from documentation
- **Individual script entries** from `.gitignore` (consolidated to `scripts/`)

### Fixed
- **Terraform lifecycle policies** uncommented and properly configured
- **Documentation cleanup** removing references to non-existent scripts
- **Security alert handling** for service-specific S3 buckets

### Technical Details
- **CloudTrail module**: Implements dual-bucket approach with conditional `prevent_destroy`
- **GuardDuty module**: Implements dual-bucket approach with conditional `prevent_destroy`
- **Root module**: Passes `prevent_destroy` variable to sub-modules
- **Test deployment**: Automatically sets `prevent_destroy = false` for complete cleanup

## [0.2.0] - 2025-08-06

### Added
- Complete AWS Landing Zone implementation
- VPC module with public/private subnets across 2 AZs
- CloudTrail logging with S3 bucket and KMS encryption
- AWS Config with managed rules and SNS notifications
- IAM baseline roles (ReadOnlyAdmin, PowerUserRestrictedIAM)
- GuardDuty threat detection with S3 findings export
- Budget monitoring and alerts
- Security Hub integration
- Macie data classification
- Comprehensive test suite with Terratest
- GitHub Actions CI/CD workflows
- PowerShell test deployment script
- Local testing documentation

### Changed
- Project structure reorganized for modularity
- Documentation enhanced with architecture diagrams
- CI/CD pipeline optimized for security and compliance

## [0.1.0] - 2025-07-15

### Added
- Initial project setup
- Basic documentation structure
- License and contribution guidelines 