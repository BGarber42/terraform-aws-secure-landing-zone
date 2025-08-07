# CI/CD Workflow Structure

This repository uses a multi-stage CI/CD approach to optimize efficiency and ensure quality at each stage of development.

## Workflow Overview

### 1. PR Checks (`pr-checks.yml`)
**Trigger:** Pull requests to `develop` branch
**Purpose:** Fast feedback for developers

**Jobs:**
- **Format & Lint:** Terraform formatting and TFLint checks
- **Validate:** Terraform validation for all examples (no AWS credentials needed)
- **Security Scan:** tfsec security scanning
- **Documentation:** Basic documentation checks

**Benefits:**
- ✅ Fast feedback (no AWS costs)
- ✅ Catches syntax and security issues early
- ✅ No resource creation during development

### 2. Develop Validation (`ci.yml`)
**Trigger:** Commits to `develop` branch
**Purpose:** Comprehensive validation before main

**Jobs:**
- **Format & Lint:** Terraform formatting and TFLint checks
- **Validate:** Terraform validation for all examples
- **Security Scan:** tfsec security scanning
- **Documentation:** Documentation checks

**Benefits:**
- ✅ Ensures develop branch quality
- ✅ Catches issues before they reach main
- ✅ No expensive testing on every commit

### 3. Main Validation (`main-validation.yml`)
**Trigger:** Commits to `main` branch
**Purpose:** Full validation and testing for production readiness

**Jobs:**
- **Format & Lint:** Terraform formatting and TFLint checks
- **Validate & Plan:** Full terraform plan with AWS credentials
- **Security Scan:** tfsec security scanning
- **Terratest:** Full integration testing with AWS resources
- **Documentation:** Documentation checks

**Benefits:**
- ✅ Full validation with real AWS resources
- ✅ Integration testing with actual infrastructure
- ✅ Production readiness verification

## Workflow Strategy

### Development Flow
1. **Feature Branch** → **PR to develop** → `pr-checks.yml` runs
2. **develop** → **PR to main** → `ci.yml` runs on develop
3. **main** → `main-validation.yml` runs full validation

### Cost Optimization
- **PR Checks:** No AWS costs (validation only)
- **Develop:** Minimal AWS costs (validation only)
- **Main:** Full AWS costs (testing with real resources)

### Quality Gates
- **PR Level:** Syntax, security, basic validation
- **Develop Level:** Comprehensive validation
- **Main Level:** Full integration testing



## Troubleshooting

### Common Issues

1. **PR Checks Failing**
   - Check terraform fmt output
   - Review TFLint warnings
   - Verify security scan results

2. **Develop Validation Failing**
   - Ensure all examples validate
   - Check for missing variables
   - Review documentation completeness

3. **Main Validation Failing**
   - Check AWS credentials
   - Review Terratest logs
   - Verify resource creation permissions

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
