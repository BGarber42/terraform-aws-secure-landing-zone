# CI/CD Workflows

This project uses GitHub Actions for continuous integration and deployment with a **main + feature branches** approach.

## Workflow Overview

### 1. PR Checks (`pr-checks.yml`)
**Trigger:** Pull requests to `main` branch
**Purpose:** Validate external contributions and feature branches

**Jobs:**
- **Format & Lint:** Terraform formatting and TFLint checks
- **Validate:** Basic terraform validation for all examples
- **Security Scan:** tfsec security scanning with SARIF upload
- **Documentation:** Documentation structure checks

### 2. Main Validation (`main-validation.yml`)
**Trigger:** Commits to `main` branch
**Purpose:** Essential validation for production readiness

**Jobs:**
- **Format & Lint:** Terraform formatting and TFLint checks
- **Validate & Plan:** Full terraform plan with AWS credentials for all examples
- **Security Scan:** tfsec security scanning with SARIF upload
- **Terratest:** Full integration testing with AWS resources (basic, security, full)
- **Documentation:** Documentation checks

## Workflow Strategy

### For Small Changes (Direct to Main)
```bash
# Quick fixes, documentation updates, small tweaks
git commit -m "docs: fix typo in README"
git push origin main
```

### For Larger Features (Feature Branches)
```bash
# Create feature branch
git checkout -b feature/new-feature
# ... work on feature ...
git push origin feature/new-feature

# Create PR for review
gh pr create --title "feat: add new feature" --base main
```

### For External Contributions
```bash
# Contributors fork and create feature branches
git checkout -b feature/external-contribution
# ... work ...
git push origin feature/external-contribution
# Create PR: feature/external-contribution → main
```

## Status Checks

### Main Branch Checks (Required)
- ✅ **Terraform Format and Lint** (code quality)
- ✅ **Terraform Validate and Plan (basic)** (syntax validation)
- ✅ **Security Scan** (security analysis)

### PR Checks (Required for External Contributions)
- ✅ **Terraform Format and Lint** (code quality)
- ✅ **Terraform Validate** (syntax validation)
- ✅ **Security Scan** (security analysis)
- ✅ **Documentation Check** (structure validation)

## Technical Details

### Triggers
- **PR Checks**: `pull_request` to `main`
- **Main Validation**: `push` to `main`

### Permissions
- **Contents**: Read access for repository content
- **Security Events**: Write access for SARIF uploads

### Environment Variables
- **AWS_DEFAULT_REGION**: us-east-1
- **TF_LOG**: INFO for debugging

### Matrix Testing
- **Examples**: basic, full, advanced
- **Tests**: basic, security, full

## Troubleshooting

### Common Issues
1. **Workflow not triggering**: Check branch name and trigger conditions
2. **AWS credentials**: Ensure secrets are configured in repository settings
3. **Terraform version**: Verify version compatibility (>= 1.5.0)
4. **Test failures**: Check AWS region and resource availability

### Debugging
- Enable `TF_LOG=INFO` for detailed Terraform output
- Check workflow logs for specific error messages
- Verify AWS credentials and permissions
- Test locally before pushing changes
