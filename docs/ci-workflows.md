# CI/CD Workflow Structure

This repository uses a streamlined CI/CD approach optimized for the linear history workflow with two main workflows.

## Workflow Overview

### 1. PR Checks (`pr-checks.yml`)
**Trigger:** Pull requests to `develop` branch
**Purpose:** Fast feedback for developers during feature development

**Jobs:**
- **Format & Lint:** Terraform formatting and TFLint checks
- **Validate:** Terraform validation for all examples (basic, full, advanced)
- **Security Scan:** tfsec security scanning with SARIF upload
- **Documentation:** Basic documentation checks

**Benefits:**
- ✅ Fast feedback (no AWS costs)
- ✅ Catches syntax and security issues early
- ✅ No resource creation during development
- ✅ Matrix testing across all examples

### 2. Main Validation (`main-validation.yml`)
**Trigger:** Commits to `main` branch
**Purpose:** Essential validation for production readiness

**Jobs:**
- **Format & Lint:** Terraform formatting and TFLint checks
- **Validate & Plan:** Full terraform plan with AWS credentials for all examples
- **Security Scan:** tfsec security scanning with SARIF upload
- **Terratest:** Full integration testing with AWS resources (basic, security, full)
- **Documentation:** Documentation checks

**Benefits:**
- ✅ Essential validation with real AWS resources
- ✅ Integration testing with actual infrastructure
- ✅ Production readiness verification
- ✅ Comprehensive testing across all examples

### Simplified Protection Strategy

This project uses **minimal branch protection** to reduce workflow friction:

- **Main Branch**: Only essential status checks required (3 checks vs 9 previously)
- **Develop Branch**: No specific protection rules (flexible development)
- **Admin Bypass**: Repository owner can merge releases directly
- **Linear History**: Maintained for clean commit history

## Workflow Strategy

### Development Flow
1. **Feature Branch** → **PR to develop** → `pr-checks.yml` runs
2. **develop** → **Release process** → `main-validation.yml` runs on main

### Cost Optimization
- **PR Checks:** No AWS costs (validation only)
- **Main Validation:** Full AWS costs (testing with real resources)

### Quality Gates
- **PR Level:** Syntax, security, basic validation
- **Main Level:** Full integration testing with real AWS resources

## Job Details

### PR Checks Jobs

#### Format & Lint
- Terraform format checking (`terraform fmt -check -recursive`)
- TFLint static analysis
- No AWS credentials required

#### Validate
- Matrix testing across basic, full, and advanced examples
- Terraform init and validate for each example
- No AWS credentials required

#### Security Scan
- tfsec security scanning
- SARIF file generation and upload to GitHub Security tab
- Comprehensive security analysis

#### Documentation
- README.md existence check
- Examples directory structure validation
- Documentation files validation

### Main Validation Jobs

#### Format & Lint
- Same as PR checks
- Ensures code quality on main branch

#### Validate & Plan
- Matrix testing across basic, full, and advanced examples
- Full terraform plan with AWS credentials
- Real AWS resource validation

#### Security Scan
- Same as PR checks
- Security validation for production code

#### Terratest
- Matrix testing across basic, security, and full test suites
- Full integration testing with AWS resources
- 30-minute timeout for comprehensive testing
- Real infrastructure validation

#### Documentation
- Same as PR checks
- Ensures documentation completeness for releases

## Workflow Triggers

### PR Checks
```yaml
on:
  pull_request:
    branches: [ develop ]
```

### Main Validation
```yaml
on:
  push:
    branches: [ main ]
```

## Permissions

Both workflows use:
```yaml
permissions:
  contents: read
  security-events: write
```

## Environment Variables

Both workflows use:
```yaml
env:
  AWS_DEFAULT_REGION: us-east-1
  TF_LOG: INFO
```

## Troubleshooting

### Common Issues

1. **PR Checks Failing**
   - Check terraform fmt output
   - Review TFLint warnings
   - Verify security scan results
   - Ensure all examples validate

2. **Main Validation Failing**
   - Check AWS credentials
   - Review Terratest logs
   - Verify resource creation permissions
   - Check terraform plan output

### Local Testing

```bash
# Test formatting
terraform fmt -check -recursive

# Test linting
tflint --init && tflint

# Test validation
cd examples/basic && terraform init && terraform validate

# Run tests locally
cd test && go test -timeout 30m -v
```

## Integration with Git Workflow

- **Feature Development:** PR checks ensure quality before merging to develop
- **Release Process:** Main validation ensures production readiness
- **Linear History:** Workflows support the develop → main workflow
- **Branch Protection:** Status checks required for both develop and main branches
