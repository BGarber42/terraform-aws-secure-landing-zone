# Git Workflow: Linear History

This project uses a linear history workflow to maintain clean commit history and simplify release management.

## Quick Reference

### 1. Creating a New Feature
```bash
# Start from develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: add new feature"
git push origin feature/your-feature-name

# Create PR: feature → develop
gh pr create --title "feat: add new feature" --base develop
```

### 2. Merging Feature to Develop
```bash
# Review PR in GitHub
# Ensure all checks pass
# Get required approval (1 reviewer)
# Merge with rebase to maintain linear history
gh pr merge <PR_NUMBER> --rebase
```

### 3. Creating a Versioned Release

#### Option A: Direct Release (Recommended)
```bash
# Create release branch from develop
git checkout develop
git checkout -b release/v1.2.3

# Update CHANGELOG.md with release notes
# Edit CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: update CHANGELOG for v1.2.3"
git push origin release/v1.2.3

# Merge develop into main
git checkout main
git merge develop --no-ff -m "Release v1.2.3"

# Create version tag
git tag v1.2.3
git push origin main
git push origin v1.2.3

# Create GitHub release
gh release create v1.2.3 --title "Release v1.2.3" --notes-file CHANGELOG.md

# Reset develop to match main
git checkout develop
git reset --hard main
git push origin develop --force
```

#### Option B: PR-Based Release
```bash
# Create release branch from develop
git checkout develop
git checkout -b release/v1.2.3

# Update CHANGELOG.md with release notes
# Edit CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: update CHANGELOG for v1.2.3"
git push origin release/v1.2.3

# Create PR: release → main
gh pr create --title "Release v1.2.3" --base main

# After PR is merged, create tag and release
git checkout main
git pull origin main
git tag v1.2.3
git push origin v1.2.3

# Create GitHub release
gh release create v1.2.3 --title "Release v1.2.3" --notes-file CHANGELOG.md

# Reset develop to match main
git checkout develop
git reset --hard main
git push origin develop --force
```

> **Note**: For additional release automation scripts, see [`scripts/README.md`](../scripts/README.md).

## Workflow Overview

```
main:     A---B---C---D (release commits)
develop:  A---B---C---D (development commits)
feature:  A---B---E---F (feature branches)
```

## Branch Strategy

### Main Branch (`main`)
- **Purpose**: Production-ready code and releases
- **Protection**: 
  - Requires 2 approvals
  - Requires code owner review
  - Linear history enforced
  - Required signatures
  - Only merge commits allowed
- **Workflow**: Receives fast-forward merges from `develop` for releases

### Develop Branch (`develop`)
- **Purpose**: Integration branch for ongoing development
- **Protection**:
  - Requires 1 approval
  - Only rebase merges allowed
  - Status checks required
- **Workflow**: Receives rebase merges from feature branches

### Feature Branches
- **Purpose**: Individual features and fixes
- **Naming**: `feature/description` or `fix/description`
- **Workflow**: Created from `develop`, merged back via PR with rebase

## Development Process

### 1. Starting New Work
```bash
# Ensure develop is up to date
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name
```

### 2. Making Changes
```bash
# Make your changes
git add .
git commit -m "feat: add new feature"

# Push to remote
git push origin feature/your-feature-name
```

### 3. Creating Pull Request
- Create PR from feature branch → `develop`
- Ensure all status checks pass
- Get required approvals
- Merge with rebase (maintains linear history)

### 4. Release Process
```bash
# When ready for release
# 1. Create release branch from develop
git checkout develop
git checkout -b release/v1.2.3

# 2. Update CHANGELOG.md with release notes
# Edit CHANGELOG.md with release notes
git add CHANGELOG.md
git commit -m "docs: update CHANGELOG for v1.2.3"
git push origin release/v1.2.3

# 3. Create PR: release → main
gh pr create --title "Release v1.2.3" --base main

# 4. After PR is merged, create tag and release
git checkout main
git pull origin main
git tag v1.2.3
git push origin v1.2.3

# 5. Create GitHub release
gh release create v1.2.3 --title "Release v1.2.3" --notes-file CHANGELOG.md

# 6. Reset develop to match main
git checkout develop
git reset --hard main
git push origin develop --force
```

### 5. Post-Release Cleanup
```bash
# Develop branch is automatically reset to match main
# This maintains linear history and prepares for next development cycle
```

## Benefits

1. **Clean History**: Single linear commit history
2. **Easy Releases**: Simple fast-forward merges
3. **Terraform Registry**: Clean history important for module releases
4. **No Merge Clutter**: No unnecessary merge commits
5. **Clear Ownership**: Each commit has clear ownership

## Branch Protection Rules

### Develop Branch
- ✅ Require pull request reviews before merging
- ✅ Require 1 approving review
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Require conversation resolution before merging
- ✅ Allow rebase merging only

### Main Branch
- ✅ Require pull request reviews before merging
- ✅ Require 2 approving reviews
- ✅ Require code owner reviews
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Require conversation resolution before merging
- ✅ Require linear history
- ✅ Require signed commits
- ✅ Allow merge commits only

## Status Checks

### Develop Branch Checks
- Terraform Format and Lint
- Terraform Validate (basic/full/advanced)
- Security Scan
- Documentation Check

### Main Branch Checks
- Terraform Format and Lint
- Terraform Validate and Plan (basic/full/advanced)
- Security Scan
- Terratest (basic/security/full)
- Documentation Check

## Best Practices

1. **Commit Messages**: Use conventional commits format
   - `feat: add new feature`
   - `fix: resolve issue`
   - `docs: update documentation`
   - `refactor: improve code structure`

2. **Branch Naming**: Use descriptive names
   - `feature/add-vpc-module`
   - `fix/security-scan-issues`
   - `docs/update-readme`

3. **Small Commits**: Keep commits focused and small
4. **Regular Updates**: Keep feature branches up to date with develop
5. **Clean History**: Squash commits when appropriate during PR review

## Troubleshooting

### If develop is behind main
```bash
git checkout develop
git rebase main
git push origin develop --force
```

### If feature branch is behind develop
```bash
git checkout feature/your-branch
git rebase develop
git push origin feature/your-branch --force
```

### If merge conflicts occur
```bash
# Resolve conflicts manually
git add .
git rebase --continue
```

## Simplified Release Workflow

### When Release Branches Are Required
- **Branch Protection**: Develop branch requires PR reviews, cannot commit directly
- **Release Preparation**: Need to update CHANGELOG.md and prepare release notes
- **Linear History**: Release script expects develop → main workflow
- **Status Checks**: Release branches allow proper CI/CD validation

### Release Process (With Release Branches)
1. **Create release branch** from develop
2. **Update CHANGELOG.md** with release notes in release branch
3. **Create PR** from release branch to main (for status checks)
4. **Merge PR** and create version tag
5. **Create GitHub release** with changelog notes
6. **Reset develop** to match main for linear history

### When to Skip Release Branches
- **Hotfixes**: Direct develop → main for urgent fixes
- **Simple Releases**: When no CHANGELOG updates needed
- **Automated Releases**: When CI/CD handles release preparation

## Release Management

1. **Versioning**: Use semantic versioning (MAJOR.MINOR.PATCH)
2. **Changelog**: Update CHANGELOG.md with release notes
3. **Tagging**: Tag releases with version numbers
4. **Terraform Registry**: Releases are automatically published to registry

## Integration with CI/CD

- **PR Checks**: Lightweight validation for develop branch
- **Main Validation**: Comprehensive validation for main branch
- **Security Scanning**: tfsec integration for security analysis
- **Testing**: Terratest for infrastructure validation

## Workflow Optimizations

This project includes automated release scripts to streamline the release process. For detailed documentation of these scripts, see [`scripts/README.md`](../scripts/README.md).

### Benefits of Optimization
- ✅ **Reduced Manual Steps**: Automated CHANGELOG updates
- ✅ **Consistent Process**: Standardized release workflow
- ✅ **Error Prevention**: Scripts validate prerequisites
- ✅ **Clear Instructions**: Built-in guidance for next steps
- ✅ **Flexible Options**: Choose automated or manual process
