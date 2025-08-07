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

## [0.4.0] - 2024-12-19

### Added
- **EC2Role** to default IAM roles for better EC2 instance compatibility
- **Comprehensive advanced feature documentation** in README.md
  - Macie custom data identifiers configuration examples
  - Security Hub action targets documentation
  - Budget actions and automated cost control examples
  - Resource protection with `prevent_destroy` documentation
- **Enhanced .gitignore** with proper lock file exclusions and development patterns

### Changed
- **Standardized variable defaults** across modules (`budget_limit_usd` to 1000)
- **Fixed Macie variable naming** consistency (`finding_publishing_frequency` → `macie_finding_publishing_frequency`)
- **Updated example configurations** to use automatic account ID detection
- **Enhanced README.md** with comprehensive advanced features section
- **Improved test configurations** with proper variable names and paths

### Fixed
- **Critical IAM module reference** - Added EC2Role to default roles and made reference conditional
- **Duplicate terraform blocks** removed from Security Hub and Macie modules
- **Test path issues** - Fixed non-existent module path references
- **Variable naming inconsistencies** across modules
- **Example configuration cleanup** - Removed commented account_id variables
- **Lock file configuration** - Proper .gitignore exclusions for published modules

### Technical Details
- **IAM Module**: Added EC2Role with `AmazonEC2ReadOnlyAccess` policy
- **Macie Module**: Renamed variable for consistency and removed duplicate terraform block
- **Security Hub Module**: Removed duplicate terraform block to prevent provider conflicts
- **Test Files**: Updated paths and variable names for proper compilation
- **Documentation**: Added comprehensive examples for advanced features
- **Git Workflow**: Proper lock file handling for published Terraform modules

## [0.3.0] - 2024-08-07

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

## [0.2.0] - 2024-08-06

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

## [0.1.0] - 2024-01-15

### Added
- Initial project setup
- Basic documentation structure
- License and contribution guidelines 